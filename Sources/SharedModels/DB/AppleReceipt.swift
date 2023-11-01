import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct AppleReceipt: Codable, Equatable {
  public typealias Id = Tagged<Self, UUID>

  public var createdAt: Date
  public var id: Id
  public var playerId: Player.Id
  public var receipt: AppleVerifyReceiptResponse
}

#if DEBUG
  extension AppleReceipt {
    public static let mock = Self(
      createdAt: .mock,
      id: .init(rawValue: .deadbeef),
      playerId: .init(rawValue: .deadbeef),
      receipt: .mock
    )
  }
#endif
