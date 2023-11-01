import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct SharedGame: Codable, Equatable {
  public typealias Code = Tagged<Self, String>
  public typealias Id = Tagged<Self, UUID>

  public let code: Code
  public let createdAt: Date
  public let gameMode: GameMode
  public let id: Id
  public let language: Language
  public let moves: Moves
  public let playerId: Player.Id
  public let puzzle: ArchivablePuzzle
}
