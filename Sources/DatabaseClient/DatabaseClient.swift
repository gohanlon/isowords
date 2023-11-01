import Build
import Either
import Foundation
import MemberwiseInit
import SharedModels
import SnsClient

@MemberwiseInit(.public)
public struct DatabaseClient {
  public var completeDailyChallenge:
    (DailyChallenge.Id, Player.Id) -> EitherIO<Error, DailyChallengePlay>
  public var createTodaysDailyChallenge:
    (CreateTodaysDailyChallengeRequest) -> EitherIO<Error, DailyChallenge>
  public var fetchActiveDailyChallengeArns: () -> EitherIO<Error, [DailyChallengeArn]>
  public var fetchAppleReceipt: (Player.Id) -> EitherIO<Error, AppleReceipt?>
  public var fetchDailyChallengeById: (DailyChallenge.Id) -> EitherIO<Error, DailyChallenge>
  public var fetchDailyChallengeHistory:
    (DailyChallengeHistoryRequest) -> EitherIO<Error, [DailyChallengeHistoryResponse.Result]>
  public var fetchDailyChallengeReport:
    (DailyChallengeReportRequest) -> EitherIO<Error, [DailyChallengeReportResult]>
  public var fetchDailyChallengeResult:
    (DailyChallengeRankRequest) -> EitherIO<Error, DailyChallengeResult>
  public var fetchDailyChallengeResults:
    (DailyChallengeResultsRequest) -> EitherIO<Error, [FetchDailyChallengeResultsResponse.Result]>
  public var fetchLeaderboardSummary:
    (FetchLeaderboardSummaryRequest) -> EitherIO<Error, LeaderboardScoreResult.Rank>
  public var fetchLeaderboardWeeklyRanks:
    (Language, Player) -> EitherIO<Error, [FetchWeekInReviewResponse.Rank]>
  public var fetchLeaderboardWeeklyWord:
    (Language, Player) -> EitherIO<Error, FetchWeekInReviewResponse.Word?>
  public var fetchPlayerByAccessToken: (AccessToken) -> EitherIO<Error, Player?>
  public var fetchPlayerByDeviceId: (DeviceId) -> EitherIO<Error, Player?>
  public var fetchPlayerByGameCenterLocalPlayerId:
    (GameCenterLocalPlayerId) -> EitherIO<Error, Player?>
  public var fetchRankedLeaderboardScores:
    (FetchLeaderboardRequest) -> EitherIO<Error, [FetchLeaderboardResponse.Entry]>
  public var fetchSharedGame: (SharedGame.Code) -> EitherIO<Error, SharedGame>
  public var fetchTodaysDailyChallenges: (Language) -> EitherIO<Error, [DailyChallenge]>
  public var fetchVocabLeaderboard:
    (Language, Player, TimeScope) -> EitherIO<
      Error, [FetchVocabLeaderboardResponse.Entry]
    >
  public var fetchVocabLeaderboardWord: (Word.Id) -> EitherIO<Error, FetchVocabWordResponse>
  public var insertPlayer: (InsertPlayerRequest) -> EitherIO<Error, Player>
  public var insertPushToken: (InsertPushTokenRequest) -> EitherIO<Error, Void>
  public var insertSharedGame: (CompletedGame, Player) -> EitherIO<Error, SharedGame>
  public var migrate: () -> EitherIO<Error, Void>
  public var shutdown: () -> EitherIO<Error, Void>
  public var startDailyChallenge:
    (DailyChallenge.Id, Player.Id) -> EitherIO<Error, DailyChallengePlay>
  public var submitLeaderboardScore: (SubmitLeaderboardScore) -> EitherIO<Error, LeaderboardScore>
  public var updateAppleReceipt: (Player.Id, AppleVerifyReceiptResponse) -> EitherIO<Error, Void>
  public var updatePlayer: (UpdatePlayerRequest) -> EitherIO<Error, Player>
  public var updatePushSetting:
    (Player.Id, PushNotificationContent.CodingKeys, Bool) -> EitherIO<Error, Void>

  public struct DailyChallengeReportResult: Codable, Equatable {
    public let arn: EndpointArn
    public let gameMode: GameMode
    public let outOf: Int
    public let rank: Int?
    public let score: Int?
  }

  @MemberwiseInit(.public)
  public struct DailyChallengeArn: Codable, Equatable {
    public var arn: EndpointArn
    public var endsAt: Date
  }

  @MemberwiseInit(.public)
  public struct DailyChallengeResultsRequest {
    public let gameMode: GameMode
    public let gameNumber: DailyChallenge.GameNumber?
    public let language: Language
    public let playerId: Player.Id
  }

  @MemberwiseInit(.public)
  public struct DailyChallengeHistoryRequest {
    public let gameMode: GameMode
    public let language: Language
    public let playerId: Player.Id
  }

  @MemberwiseInit(.public)
  public struct DailyChallengeReportRequest {
    public let gameMode: GameMode
    public let language: Language
  }

  @MemberwiseInit(.public)
  public struct FetchLeaderboardSummaryRequest {
    public let gameMode: GameMode
    public let timeScope: TimeScope
    public let type: SummaryType

    public enum SummaryType {
      case player(scoreId: LeaderboardScore.Id, playerId: Player.Id)
      case anonymous(score: Int)
    }
  }

  @MemberwiseInit(.public)
  public struct FetchLeaderboardRequest {
    public let gameMode: GameMode
    public let language: Language
    public let playerId: Player.Id
    public let timeScope: TimeScope
  }

  @MemberwiseInit(.public)
  public struct CreateTodaysDailyChallengeRequest {
    public let gameMode: GameMode
    public let language: Language
    public let puzzle: ArchivablePuzzle
  }

  @MemberwiseInit(.public)
  public struct InsertPlayerRequest: Equatable {
    public var deviceId: DeviceId
    public var displayName: String?
    public var gameCenterLocalPlayerId: GameCenterLocalPlayerId?
    public var timeZone: String

    #if DEBUG
      public static let blob = Self(
        deviceId: .init(rawValue: UUID(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef")!),
        displayName: "Blob",
        gameCenterLocalPlayerId: "_id:blob",
        timeZone: "America/New_York"
      )

      public static let blobJr = Self(
        deviceId: .init(rawValue: UUID(uuidString: "cafebeef-dead-beef-dead-beefdeadbeef")!),
        displayName: "Blob Jr",
        gameCenterLocalPlayerId: "_id:blob_jr",
        timeZone: "America/New_York"
      )

      public static let blobSr = Self(
        deviceId: .init(rawValue: UUID(uuidString: "beefbeef-dead-beef-dead-beefdeadbeef")!),
        displayName: "Blob Sr",
        gameCenterLocalPlayerId: "_id:blob_sr",
        timeZone: "America/New_York"
      )
    #endif
  }

  @MemberwiseInit(.public)
  public struct InsertPushTokenRequest: Equatable {
    public let arn: String
    public let authorizationStatus: PushAuthorizationStatus
    public let build: Build.Number
    public let player: Player
    public let token: String
  }

  public struct LeaderboardWeeklyRank: Codable, Equatable {
    public let gameMode: GameMode
    public let outOf: Int
    public let rank: Int
  }

  public struct LeaderboardWeeklyWord: Codable, Equatable {
    public let letters: String
    public let score: Int
  }

  @MemberwiseInit(.public)
  public struct SubmitLeaderboardScore: Equatable {
    public let dailyChallengeId: DailyChallenge.Id?
    public let gameContext: GameContext
    public let gameMode: GameMode
    public let language: Language
    public let moves: Moves
    public let playerId: Player.Id
    public let puzzle: ArchivablePuzzle
    public let score: Int
    public let words: [SubmitLeaderboardWord]

    public enum GameContext: String, Codable, Equatable {
      case dailyChallenge
      case solo
      case turnBased
    }
  }

  @MemberwiseInit(.public)
  public struct SubmitLeaderboardWord: Equatable {
    public let moveIndex: Int
    public let score: Int
    public let word: String
  }

  @MemberwiseInit(.public)
  public struct DailyChallengeRankRequest: Equatable {
    public let dailyChallengeId: DailyChallenge.Id
    public let playerId: Player.Id
  }

  @MemberwiseInit(.public)
  public struct UpdatePlayerRequest {
    public let displayName: String?
    public let gameCenterLocalPlayerId: GameCenterLocalPlayerId?
    public let playerId: Player.Id
    public let timeZone: String
  }
}
