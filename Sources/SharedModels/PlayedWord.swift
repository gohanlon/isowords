import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct PlayedWord: Equatable {
  public var isYourWord: Bool
  public var reactions: [Move.PlayerIndex: Move.Reaction]?
  public var score: Int
  public var word: String

  public var orderedReactions: [Move.Reaction]? {
    self.reactions?.sorted(by: { $0.key < $1.key }).map(\.value)
  }
}
