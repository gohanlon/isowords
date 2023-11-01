import MemberwiseInit

@MemberwiseInit(.public)
public struct SavedGamesState: Codable, Equatable {
  public var dailyChallengeUnlimited: InProgressGame? = nil
  public var unlimited: InProgressGame? = nil
}
