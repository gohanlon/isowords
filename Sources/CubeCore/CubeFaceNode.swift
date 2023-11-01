import Combine
import ComposableArchitecture
import MemberwiseInit
import SceneKit
import SharedModels
import SwiftUI

public class CubeFaceNode: SCNNode {
  @MemberwiseInit(.public)
  public struct ViewState: Equatable {
    public var cubeFace: CubeFace
    public var letterIsHidden: Bool = false
    public var status: Status

    public enum Status {
      case deselected
      case selectable
      case selected
    }
  }

  public let side: CubeFace.Side

  private var cancellables: Set<AnyCancellable> = []
  private let uuid = UUID()
  private let viewStore: ViewStore<ViewState, Never>

  public init(
    letterGeometry: SCNGeometry,
    store: Store<ViewState, Never>
  ) {
    self.viewStore = ViewStore(store, observe: { $0 })
    self.side = self.viewStore.cubeFace.side

    super.init()

    let letterNode = SCNNode(geometry: letterGeometry)
    letterNode.castsShadow = false
    letterNode.name = "text"
    letterNode.position = .init(0, 0, 0.01)
    self.addChildNode(letterNode)

    self.category = [.cubeFace, .shadowSurface]
    self.name = "Face: \(self.viewStore.cubeFace.side)"

    switch self.viewStore.cubeFace.side {
    case .top:
      self.eulerAngles = SCNVector3(-CGFloat.pi / 2, 0, 0)
      self.position = SCNVector3(0, 0.5, 0)
    case .left:
      self.position = SCNVector3(0, 0, 0.5)
    case .right:
      self.eulerAngles = SCNVector3(0, CGFloat.pi / 2, 0)
      self.position = SCNVector3(0.5, 0, 0)
    }

    self.viewStore.publisher
      .sink { [weak self] state in
        guard let self = self else { return }
        guard state.cubeFace.useCount <= 2 else { return }
        self.geometry = plane(
          status: state.status,
          useCount: state.cubeFace.useCount
        )
        letterNode.isHidden = state.letterIsHidden
      }
      .store(in: &self.cancellables)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
