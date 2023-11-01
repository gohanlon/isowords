import MemberwiseInit
import SwiftUI

@MemberwiseInit(.public)
public struct ActivityView: UIViewControllerRepresentable {
  public var activityItems: [Any]

  public func makeUIViewController(context: Context) -> UIActivityViewController {
    let controller = UIActivityViewController(
      activityItems: self.activityItems,
      applicationActivities: nil
    )
    return controller
  }

  public func updateUIViewController(
    _ uiViewController: UIActivityViewController, context: Context
  ) {}
}
