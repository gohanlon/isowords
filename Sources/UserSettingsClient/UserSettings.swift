import MemberwiseInit
import Styleguide
import UIKit

@MemberwiseInit(.public)
public struct UserSettings: Codable, Equatable {
  public var appIcon: AppIcon? = nil
  public var colorScheme: ColorScheme = .system
  public var enableGyroMotion: Bool = true
  public var enableHaptics: Bool = true
  public var enableNotifications: Bool = false
  public var enableReducedAnimation: Bool = false
  public var musicVolume: Float = 1
  public var sendDailyChallengeReminder: Bool = true
  public var sendDailyChallengeSummary: Bool = true
  public var soundEffectsVolume: Float = 1

  public enum ColorScheme: String, CaseIterable, Codable {
    case dark
    case light
    case system

    public var userInterfaceStyle: UIUserInterfaceStyle {
      switch self {
      case .dark:
        return .dark
      case .light:
        return .light
      case .system:
        return .unspecified
      }
    }
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.appIcon = try? container.decode(AppIcon.self, forKey: .appIcon)
    self.colorScheme = (try? container.decode(ColorScheme.self, forKey: .colorScheme)) ?? .system
    self.enableGyroMotion = (try? container.decode(Bool.self, forKey: .enableGyroMotion)) ?? true
    self.enableHaptics = (try? container.decode(Bool.self, forKey: .enableHaptics)) ?? true
    self.enableNotifications =
      (try? container.decode(Bool.self, forKey: .enableNotifications)) ?? false
    self.enableReducedAnimation =
      (try? container.decode(Bool.self, forKey: .enableReducedAnimation)) ?? false
    self.musicVolume = (try? container.decode(Float.self, forKey: .musicVolume)) ?? 1
    self.soundEffectsVolume = (try? container.decode(Float.self, forKey: .soundEffectsVolume)) ?? 1
    self.sendDailyChallengeReminder =
      (try? container.decode(Bool.self, forKey: .sendDailyChallengeReminder)) ?? true
    self.sendDailyChallengeSummary =
      (try? container.decode(Bool.self, forKey: .sendDailyChallengeSummary)) ?? true
  }
}
