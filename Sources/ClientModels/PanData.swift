import CoreGraphics
import MemberwiseInit
import SharedModels

@MemberwiseInit(.public)
public struct PanData: Equatable {
  public var normalizedPoint: CGPoint
  public var cubeFaceState: IndexedCubeFace
}
