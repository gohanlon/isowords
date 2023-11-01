import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct FetchLeaderboardResponse: Codable, Equatable {
  public let entries: [Entry]

  @MemberwiseInit(.public)
  public struct Entry: Codable, Equatable {
    public let id: LeaderboardScore.Id
    public let isSupporter: Bool
    public let isYourScore: Bool
    public let outOf: Int
    public let playerDisplayName: String?
    public let rank: Int
    public let score: Int
  }
}
