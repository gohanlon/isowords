import MemberwiseInit

@MemberwiseInit(.public)
public struct FetchVocabLeaderboardResponse: Codable, Equatable {
  public var entries: [Entry]

  @MemberwiseInit(.public)
  public struct Entry: Codable, Equatable {
    public let denseRank: Int
    public let isSupporter: Bool
    public let isYourScore: Bool
    public let outOf: Int
    public let playerDisplayName: String?
    public let playerId: Player.Id
    public let rank: Int
    public let score: Int
    public let word: String
    public let wordId: Word.Id
  }
}
