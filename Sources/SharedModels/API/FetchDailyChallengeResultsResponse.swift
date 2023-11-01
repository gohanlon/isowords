import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct FetchDailyChallengeResultsResponse: Codable, Equatable {
  public var results: [Result]

  @MemberwiseInit(.public)
  public struct Result: Codable, Equatable {
    public var isSupporter: Bool
    public var isYourScore: Bool
    public var outOf: Int
    public var playerDisplayName: String?
    public var playerId: Player.Id
    public var rank: Int
    public var score: Int
  }
}
