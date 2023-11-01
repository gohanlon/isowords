import ApiClient
import Build
import ComposableArchitecture
import MemberwiseInit
import ServerConfigClient
import SharedModels
import Styleguide
import SwiftUI
import Tagged
import UIApplicationClient

public struct ChangelogReducer: Reducer {
  @MemberwiseInit(.public)
  public struct State: Equatable {
    public var changelog: IdentifiedArrayOf<Change.State> = []
    public var currentBuild: Build.Number = 0
    public var isRequestInFlight: Bool = false
    public var isUpdateButtonVisible: Bool = false
  }

  public enum Action: Equatable {
    case change(id: Build.Number, action: Change.Action)
    case changelogResponse(TaskResult<Changelog>)
    case task
    case updateButtonTapped
  }

  @Dependency(\.apiClient) var apiClient
  @Dependency(\.build.number) var buildNumber
  @Dependency(\.applicationClient.open) var openURL
  @Dependency(\.serverConfig) var serverConfig

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .change:
        return .none

      case let .changelogResponse(.success(changelog)):
        state.changelog = IdentifiedArray(
          uniqueElements:
            changelog
            .changes
            .sorted(by: { $0.build > $1.build })
            .enumerated()
            .map { offset, change in
              Change.State(
                change: change,
                isExpanded: offset == 0 || self.buildNumber() <= change.build
              )
            }
        )
        state.isRequestInFlight = false
        state.isUpdateButtonVisible =
          self.buildNumber() < (changelog.changes.map(\.build).max() ?? 0)

        return .none

      case .changelogResponse(.failure):
        state.isRequestInFlight = false
        return .none

      case .task:
        state.currentBuild = self.buildNumber()
        state.isRequestInFlight = true

        return .run { send in
          await send(
            .changelogResponse(
              TaskResult {
                try await self.apiClient.apiRequest(
                  route: .changelog(build: self.buildNumber()),
                  as: Changelog.self
                )
              }
            )
          )
        }

      case .updateButtonTapped:
        return .run { _ in
          _ = await self.openURL(
            self.serverConfig.config().appStoreUrl.absoluteURL,
            [:]
          )
        }
      }
    }
    .forEach(\.changelog, action: /Action.change(id:action:)) {
      Change()
    }
  }
}

@MemberwiseInit(.public)
public struct ChangelogView: View {
  @Init(.public) let store: StoreOf<ChangelogReducer>

  struct ViewState: Equatable {
    let currentBuild: Build.Number
    let isUpdateButtonVisible: Bool

    init(state: ChangelogReducer.State) {
      self.currentBuild = state.currentBuild
      self.isUpdateButtonVisible = state.isUpdateButtonVisible
    }
  }

  public var body: some View {
    WithViewStore(self.store, observe: ViewState.init) { viewStore in
      ScrollView {
        VStack(alignment: .leading) {
          if viewStore.isUpdateButtonVisible {
            HStack {
              Spacer()
              Button("Update") {
                viewStore.send(.updateButtonTapped)
              }
              .buttonStyle(ActionButtonStyle())
            }
          }

          Text("What's new?")
            .font(.largeTitle)

          ForEachStore(
            self.store.scope(
              state: { $0.changelog.filter { $0.change.build >= viewStore.currentBuild } },
              action: { .change(id: $0, action: $1) }
            )
          ) {
            ChangeView(currentBuild: viewStore.currentBuild, store: $0)
          }

          Text("Past updates")
            .font(.largeTitle)

          ForEachStore(
            self.store.scope(
              state: { $0.changelog.filter { $0.change.build < viewStore.currentBuild } },
              action: { .change(id: $0, action: $1) }
            )
          ) {
            ChangeView(currentBuild: viewStore.currentBuild, store: $0)
          }
        }
        .padding()
      }
      .task { await viewStore.send(.task).finish() }
    }
  }
}

#if DEBUG
  import Overture
  import SwiftUIHelpers

  struct ChangelogPreviews: PreviewProvider {
    static var previews: some View {
      Preview {
        ChangelogView(
          store: Store(initialState: ChangelogReducer.State()) {
            ChangelogReducer()
          } withDependencies: {
            $0.apiClient = {
              var apiClient = ApiClient.noop
              apiClient.override(
                routeCase: /ServerRoute.Api.Route.changelog(build:),
                withResponse: { _ in
                  try await OK(
                    update(Changelog.current) {
                      $0.changes.append(
                        Changelog.Change(
                          version: "1.0",
                          build: 60,
                          log: "We launched!"
                        )
                      )
                    }
                  )
                }
              )
              return apiClient
            }()
            $0.applicationClient = .noop
            $0.build.number = { 98 }
            $0.serverConfig = .noop
          }
        )
        .navigationStyle(
          title: Text("Updates"),
          navPresentationStyle: .modal,
          onDismiss: {}
        )
      }
    }
  }
#endif
