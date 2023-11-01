import MemberwiseInit
import SwiftUI

@MemberwiseInit(.public)
public struct Hosting<Content>: UIViewControllerRepresentable where Content: View {
  @Init(.public, label: "_") private let content: Content

  @Init(.public, default: { (_: UIViewController) in }, label: "_")
  private let configure: (UIViewController) -> Void

  public func makeUIViewController(context: Context) -> UIViewController {
    let vc = UIHostingController(rootView: self.content)
    vc.view.backgroundColor = nil
    self.configure(vc)
    return vc
  }

  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
