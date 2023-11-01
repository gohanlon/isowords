import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct CompletedGame: Codable, Equatable, Sendable {
  public var cubes: ArchivablePuzzle
  public var gameContext: GameContext
  public var gameMode: GameMode
  public var gameStartTime: Date
  @Init(.public, label: "language") var _language: Language?
  public var localPlayerIndex: Move.PlayerIndex? = nil
  public var moves: Moves
  public var secondsPlayed: Int

  private enum CodingKeys: String, CodingKey {
    case cubes
    case gameContext
    case gameMode
    case gameStartTime
    case _language = "language"
    case localPlayerIndex
    case moves
    case secondsPlayed
  }

  public enum GameContext: Codable, Equatable, Sendable {
    case dailyChallenge(DailyChallenge.Id)
    case shared(SharedGame.Code)
    case solo
    case turnBased(playerIndexToId: [Move.PlayerIndex: Player.Id])

    private enum CodingKeys: CaseIterable, CodingKey {
      case dailyChallengeId
      case sharedGameCode
      case solo
      case turnBased
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      for key in CodingKeys.allCases {
        switch key {
        case .dailyChallengeId where container.contains(key):
          self = .dailyChallenge(
            try container.decode(DailyChallenge.Id.self, forKey: .dailyChallengeId))
          return
        case .sharedGameCode where container.contains(key):
          self = .shared(try container.decode(SharedGame.Code.self, forKey: .sharedGameCode))
          return
        case .turnBased where container.contains(key):
          self = .turnBased(
            playerIndexToId: (try container.decode([Int: Player.Id].self, forKey: .turnBased))
              .transformKeys(Tagged.init(rawValue:))
          )
          return
        case .solo where container.contains(key):
          self = .solo
          return
        case .dailyChallengeId, .sharedGameCode, .solo, .turnBased:
          break
        }
      }

      // If we can't find any of the keys then assume a solo game.
      self = .solo
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)

      switch self {
      case let .dailyChallenge(id):
        try container.encode(id, forKey: .dailyChallengeId)
      case let .shared(code):
        try container.encode(code, forKey: .sharedGameCode)
      case .solo:
        try container.encode(true, forKey: .solo)
      case let .turnBased(playerIndexToId):
        try container.encode(
          playerIndexToId.transformKeys(\.rawValue),
          forKey: .turnBased
        )
      }
    }
  }

  public var language: Language {
    get { self._language ?? .en }
    set { self._language = newValue }
  }

  public var localMoves: [Move] {
    self.moves
      .filter { $0.playerIndex == nil || $0.playerIndex == self.localPlayerIndex }
  }

  public var wordsByPlayerIndex: [Move.PlayerIndex: [PlayedWord]] {
    self.moves.reduce(into: [:]) { accum, move in
      guard let playerIndex = move.playerIndex else { return }

      switch move.type {
      case let .playedWord(word):
        accum[playerIndex, default: []]
          .append(
            .init(
              isYourWord: move.playerIndex == self.localPlayerIndex,
              reactions: move.reactions,
              score: move.score,
              word: self.cubes.string(from: word)
            )
          )
      case .removedCube:
        break
      }
    }
  }

  public func words(forPlayerIndex playerIndex: Move.PlayerIndex? = nil) -> [PlayedWord] {
    self.cubes.words(forMoves: .init(self.moves.filter { $0.playerIndex == playerIndex }))
  }

  public var currentScore: Int {
    self.moves.reduce(into: 0) { $0 += $1.score }
  }
}

#if DEBUG
  extension CompletedGame {
    public static let mock = Self(
      cubes: .mock,
      gameContext: .solo,
      gameMode: .timed,
      gameStartTime: .mock,
      language: .en,
      moves: [.cab],
      secondsPlayed: 10
    )
  }
#endif
