import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct StartDailyChallengeResponse: Codable, Equatable {
  public let dailyChallenge: DailyChallenge
  public let dailyChallengePlayId: DailyChallengePlay.Id
}
