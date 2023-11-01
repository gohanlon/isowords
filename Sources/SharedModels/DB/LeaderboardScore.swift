import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct LeaderboardScore: Decodable, Equatable {
  public typealias Id = Tagged<Self, UUID>

  public let createdAt: Date
  public let dailyChallengeId: DailyChallenge.Id?
  public let gameContext: GameContext
  public let gameMode: GameMode
  public let id: Id
  public let language: Language
  public let moves: Moves
  public let playerId: Player.Id
  public let puzzle: ArchivablePuzzle
  public let score: Int

  public enum GameContext: String, Codable {
    case dailyChallenge
    case solo
    case turnBased
  }
}
