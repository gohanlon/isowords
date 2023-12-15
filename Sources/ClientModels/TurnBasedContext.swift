import ComposableGameCenter
import Foundation
import MemberwiseInit
import SharedModels
import Tagged

@MemberwiseInit(.public)
public struct TurnBasedContext: Equatable {
  public var localPlayer: LocalPlayer
  public var match: TurnBasedMatch
  public var metadata: TurnBasedMatchData.Metadata

  public var currentParticipantIsLocalPlayer: Bool {
    self.match.currentParticipant?.player?.gamePlayerId == self.localPlayer.gamePlayerId
  }

  public var lastPlayedAt: Date {
    self.match.participants.lazy.compactMap(\.lastTurnDate).max() ?? self.match.creationDate
  }

  public var localParticipant: TurnBasedParticipant? {
    self.match.participants
      .first { $0.player?.gamePlayerId == self.localPlayer.gamePlayerId }
  }

  public var localPlayerIndex: Move.PlayerIndex? {
    self.match.participants
      .firstIndex(where: { $0.player?.gamePlayerId == self.localPlayer.gamePlayerId })
      .map(Tagged.init(rawValue:))
  }

  public var otherParticipant: TurnBasedParticipant? {
    self.match.participants
      .first { $0.player?.gamePlayerId != self.localPlayer.gamePlayerId }
  }

  public var otherPlayer: ComposableGameCenter.Player? {
    self.otherParticipant?.player
  }

  public var otherPlayerIndex: Move.PlayerIndex? {
    self.match.participants
      .firstIndex { $0.player?.gamePlayerId != self.localPlayer.gamePlayerId }
      .map(Tagged.init(rawValue:))
  }
}
