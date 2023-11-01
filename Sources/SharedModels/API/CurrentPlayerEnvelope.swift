import MemberwiseInit

@MemberwiseInit(.public)
public struct CurrentPlayerEnvelope: Codable, Equatable, Sendable {
  public let appleReceipt: AppleVerifyReceiptResponse?
  public var player: Player
}
