import MemberwiseInit

@MemberwiseInit(.public)
public struct DailyChallengeResult: Codable, Equatable {
  public var outOf: Int
  public var rank: Int?
  public var score: Int?
  public var started: Bool = false
}
