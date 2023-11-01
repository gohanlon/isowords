import MemberwiseInit

@MemberwiseInit(.public)
public struct VerifyReceiptEnvelope: Codable, Equatable {
  public let verifiedProductIds: [String]
}
