import MemberwiseInit

@MemberwiseInit(.public)
public struct FetchWeekInReviewResponse: Codable, Equatable {
  public let ranks: [Rank]
  public let word: Word?

  public var timedRank: Rank? {
    self.ranks.first(where: { $0.gameMode == .timed })
  }

  public var unlimitedRank: Rank? {
    self.ranks.first(where: { $0.gameMode == .unlimited })
  }

  @MemberwiseInit(.public)
  public struct Rank: Codable, Equatable {
    public let gameMode: GameMode
    public let outOf: Int
    public let rank: Int

  }

  @MemberwiseInit(.public)
  public struct Word: Codable, Equatable {
    public let letters: String
    public let score: Int
  }
}
