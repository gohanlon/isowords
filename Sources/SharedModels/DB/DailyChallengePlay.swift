import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct DailyChallengePlay: Codable, Equatable {
  public typealias Id = Tagged<Self, UUID>

  public let completedAt: Date?
  public let createdAt: Date
  public let dailyChallengeId: DailyChallenge.Id
  public let id: Id
  public let playerId: Player.Id
}
