import FirstPartyMocks
import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct FetchTodaysDailyChallengeResponse: Codable, Equatable {
  public var dailyChallenge: DailyChallenge
  public var yourResult: DailyChallengeResult

  @MemberwiseInit(.public)
  public struct DailyChallenge: Codable, Equatable {
    public var endsAt: Date
    public var gameMode: GameMode
    public var id: SharedModels.DailyChallenge.Id
    public var language: Language
  }
}

extension Array where Element == FetchTodaysDailyChallengeResponse {
  public var timed: FetchTodaysDailyChallengeResponse? {
    self.first(where: { $0.dailyChallenge.gameMode == .timed })
  }

  public var unlimited: FetchTodaysDailyChallengeResponse? {
    self.first(where: { $0.dailyChallenge.gameMode == .unlimited })
  }

  public var numberOfPlayers: Int {
    self.reduce(into: 0) {
      $0 += $1.yourResult.outOf
    }
  }
}

extension FetchTodaysDailyChallengeResponse {
  static let started = Self(
    dailyChallenge: .init(
      endsAt: .init(timeIntervalSinceNow: 1_234_567_890),
      gameMode: .unlimited,
      id: .init(rawValue: .deadbeef),
      language: .en
    ),
    yourResult: .init(
      outOf: 1_000,
      rank: nil,
      score: nil,
      started: true
    )
  )

  static let played = Self(
    dailyChallenge: .init(
      endsAt: .init(timeIntervalSinceNow: 1_234_567_890),
      gameMode: .unlimited,
      id: .init(rawValue: .deadbeef),
      language: .en
    ),
    yourResult: .init(
      outOf: 1_000,
      rank: 20,
      score: 3_000,
      started: true
    )
  )

  static let notStarted = Self(
    dailyChallenge: .init(
      endsAt: .init(timeIntervalSinceNow: 1_234_567_890),
      gameMode: .unlimited,
      id: .init(rawValue: .deadbeef),
      language: .en
    ),
    yourResult: .init(
      outOf: 1_000,
      rank: nil,
      score: nil,
      started: false
    )
  )
}
