import MemberwiseInit
import SwiftUI
import SwiftUIHelpers

@MemberwiseInit(.public)
public struct ActionButtonStyle: ButtonStyle {
  @Init(.public, default: Color.adaptiveBlack) let backgroundColor: Color
  @Init(.public, default: Color.adaptiveWhite) let foregroundColor: Color
  @Init(.public, default: true) let isActive: Bool

  public func makeBody(configuration: Self.Configuration) -> some View {
    return configuration.label
      .foregroundColor(
        self.foregroundColor
          .opacity(!configuration.isPressed ? 1 : 0.5)
      )
      .padding(.horizontal, .grid(5))
      .padding(.vertical, .grid(6))
      .background(
        RoundedRectangle(cornerRadius: 13)
          .fill(
            self.backgroundColor
              .opacity(self.isActive && !configuration.isPressed ? 1 : 0.5)
          )
      )
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
      .adaptiveFont(.matterMedium, size: 16)
  }
}

struct Buttons_Previews: PreviewProvider {
  static var previews: some View {
    let view = NavigationView {
      VStack {
        Section(header: Text("Active")) {
          Button("Button") {}
          NavigationLink("Navigation link", destination: EmptyView())
        }
        .buttonStyle(ActionButtonStyle())

        Section(header: Text("In-active")) {
          Button("Button") {}
          NavigationLink("Navigation link", destination: EmptyView())
        }
        .buttonStyle(ActionButtonStyle(isActive: false))
      }
    }

    return Group {
      view
        .environment(\.colorScheme, .light)
      view
        .environment(\.colorScheme, .dark)
    }
  }
}
