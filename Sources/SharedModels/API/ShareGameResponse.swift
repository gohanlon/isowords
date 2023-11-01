import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct SharedGameResponse: Codable, Equatable {
  public let code: SharedGame.Code
  public let id: SharedGame.Id
  public let gameMode: GameMode
  public let language: Language
  public let moves: Moves
  public let puzzle: ArchivablePuzzle
}
