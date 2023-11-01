import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct DailyChallengeHistoryResponse: Codable, Equatable {
  public var results: [Result]

  @MemberwiseInit(.public)
  public struct Result: Codable, Equatable {
    public var createdAt: Date
    public var gameNumber: DailyChallenge.GameNumber
    public var isToday: Bool
    public var rank: Int?
  }
}
