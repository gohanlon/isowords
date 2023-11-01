import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct DailyChallenge: Codable, Equatable {
  public typealias Id = Tagged<Self, UUID>
  public typealias GameNumber = Tagged<(Self, gameNumber: ()), Int>

  public var createdAt: Date
  public var endsAt: Date
  public var gameMode: GameMode
  public var gameNumber: GameNumber
  public var id: Id
  public var language: Language
  public var puzzle: ArchivablePuzzle
}

#if DEBUG
  import FirstPartyMocks

  extension DailyChallenge {
    public static let mock = Self(
      createdAt: .mock,
      endsAt: .mock,
      gameMode: .timed,
      gameNumber: 1,
      id: .init(rawValue: .dailyChallengeId),
      language: .en,
      puzzle: .mock
    )
  }
#endif
