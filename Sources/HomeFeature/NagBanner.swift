import ComposableArchitecture
import MemberwiseInit
import SwiftUI
import UpgradeInterstitialFeature

public struct NagBanner: Reducer {
  @MemberwiseInit(.public)
  public struct State: Equatable {
    @Init(.public) @PresentationState var upgradeInterstitial: UpgradeInterstitial.State? = nil
  }

  public enum Action: Equatable {
    case tapped
    case upgradeInterstitial(PresentationAction<UpgradeInterstitial.Action>)
  }

  @Dependency(\.dismiss) var dismiss

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tapped:
        state.upgradeInterstitial = .init(isDismissable: true)
        return .none

      case .upgradeInterstitial(.presented(.delegate(.fullGamePurchased))):
        return .run { _ in
          await self.dismiss()
        }

      case .upgradeInterstitial:
        return .none
      }
    }
    .ifLet(\.$upgradeInterstitial, action: /Action.upgradeInterstitial) {
      UpgradeInterstitial()
    }
  }
}

@MemberwiseInit(.public)
public struct NagBannerView: View {
  @Init(.public) let store: StoreOf<NagBanner>

  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Button {
        viewStore.send(.tapped)
      } label: {
        Marquee(duration: TimeInterval(messages.count) * 9) {
          ForEach(messages, id: \.self) { message in
            Text(message)
              .adaptiveFont(.matterMedium, size: 14)
              .foregroundColor(.isowordsRed)
          }
        }
      }
      .buttonStyle(PlainButtonStyle())
      .frame(maxWidth: .infinity, alignment: .center)
      .frame(height: 56)
      .background(Color.white.edgesIgnoringSafeArea(.bottom))
    }
    .sheet(
      store: self.store.scope(state: \.$upgradeInterstitial, action: { .upgradeInterstitial($0) }),
      content: UpgradeInterstitialView.init(store:)
    )
  }
}

let messages = [
  "Remove this annoying banner.",
  "Please, we don’t like it either.",
  "We could put an ad here, but ads suck.",
  "Seriously, we are sorry about this.",
]

#if DEBUG
  struct NagBanner_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView {
        ZStack(alignment: .bottomLeading) {
          NagBannerView(
            store: Store(initialState: NagBanner.State()) {
              NagBanner()
            }
          )
        }
      }
    }
  }
#endif
