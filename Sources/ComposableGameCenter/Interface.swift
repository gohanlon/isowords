import Combine
import ComposableArchitecture
import GameKit
import MemberwiseInit
import Tagged

public struct GameCenterClient {
  public var gameCenterViewController: GameCenterViewControllerClient
  public var localPlayer: LocalPlayerClient
  public var reportAchievements: @Sendable ([GKAchievement]) async throws -> Void
  public var showNotificationBanner: @Sendable (NotificationBannerRequest) async -> Void
  public var turnBasedMatch: TurnBasedMatchClient
  public var turnBasedMatchmakerViewController: TurnBasedMatchmakerViewControllerClient

  @MemberwiseInit(.public)
  public struct NotificationBannerRequest: Equatable {
    public var title: String?
    public var message: String?
  }
}

public struct GameCenterViewControllerClient {
  public var present: @Sendable () async -> Void
  public var dismiss: @Sendable () async -> Void
}

public struct LocalPlayerClient {
  public var authenticate: @Sendable () async throws -> Void
  public var listener: @Sendable () -> AsyncStream<ListenerEvent>
  public var localPlayer: @Sendable () -> LocalPlayer
  public var presentAuthenticationViewController: @Sendable () async -> Void

  public enum ListenerEvent: Equatable {
    case challenge(ChallengeEvent)
    case invite(InviteEvent)
    case savedGame(SavedGameEvent)
    case turnBased(TurnBasedEvent)

    public enum ChallengeEvent: Equatable {
      case didComplete(GKChallenge, issuedByFriend: GKPlayer)
      case didReceive(GKChallenge)
      case issuedChallengeWasCompleted(GKChallenge, byFriend: GKPlayer)
      case wantsToPlay(GKChallenge)
    }

    public enum InviteEvent: Equatable {
      case didAccept(GKInvite)
      case didRequestMatchWithRecipients([GKPlayer])
    }

    public enum SavedGameEvent: Equatable {
      case didModifySavedGame(GKSavedGame)
      case hasConflictingSavedGames([GKSavedGame])
    }

    public enum TurnBasedEvent: Equatable {
      case didRequestMatchWithOtherPlayers([GKPlayer])
      case matchEnded(TurnBasedMatch)
      case receivedExchangeCancellation(GKTurnBasedExchange, match: TurnBasedMatch)
      case receivedExchangeReplies([GKTurnBasedExchangeReply], match: TurnBasedMatch)
      case receivedExchangeRequest(GKTurnBasedExchange, match: TurnBasedMatch)
      case receivedTurnEventForMatch(TurnBasedMatch, didBecomeActive: Bool)
      case wantsToQuitMatch(TurnBasedMatch)
    }
  }
}

public struct TurnBasedMatchClient {
  public var endMatchInTurn: @Sendable (EndMatchInTurnRequest) async throws -> Void
  public var endTurn: @Sendable (EndTurnRequest) async throws -> Void
  public var load: @Sendable (TurnBasedMatch.Id) async throws -> TurnBasedMatch
  public var loadMatches: @Sendable () async throws -> [TurnBasedMatch]
  public var participantQuitInTurn: @Sendable (TurnBasedMatch.Id, Data) async throws -> Void
  public var participantQuitOutOfTurn: @Sendable (TurnBasedMatch.Id) async throws -> Void
  public var rematch: @Sendable (TurnBasedMatch.Id) async throws -> TurnBasedMatch
  public var remove: @Sendable (TurnBasedMatch) async throws -> Void
  public var saveCurrentTurn: @Sendable (TurnBasedMatch.Id, Data) async throws -> Void
  public var sendReminder: @Sendable (SendReminderRequest) async throws -> Void

  @MemberwiseInit(.public)
  public struct EndMatchInTurnRequest: Equatable {
    @Init(label: "for") public var matchId: TurnBasedMatch.Id
    public var matchData: Data
    public var localPlayerId: Player.Id
    public var localPlayerMatchOutcome: GKTurnBasedMatch.Outcome
    public var message: String?
  }

  @MemberwiseInit(.public)
  public struct EndTurnRequest: Equatable {
    @Init(label: "for") public var matchId: TurnBasedMatch.Id
    public var matchData: Data
    public var message: String
  }

  @MemberwiseInit(.public)
  public struct SendReminderRequest: Equatable {
    @Init(label: "for") public var matchId: TurnBasedMatch.Id
    @Init(label: "to") public var participantsAtIndices: [Int]
    @Init(label: "localizableMessageKey") public var key: String
    public var arguments: [String]
  }
}

public struct TurnBasedMatchmakerViewControllerClient {
  public var present: @Sendable (_ showExistingMatches: Bool) async throws -> Void
  public var dismiss: @Sendable () async -> Void

  public func present(showExistingMatches: Bool = true) async throws {
    try await self.present(showExistingMatches)
  }
}
