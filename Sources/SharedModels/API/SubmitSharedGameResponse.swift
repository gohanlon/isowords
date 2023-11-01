import Foundation
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct SubmitSharedGameResponse: Codable, Equatable {
  public let code: SharedGame.Code
  public let id: SharedGame.Id
  public let url: String
}
