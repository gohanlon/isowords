import DatabaseClient
import DictionaryClient
import EnvVars
import Foundation
import MailgunClient
import MemberwiseInit
import Overture
import ServerConfig
import ServerRouter
import SharedModels
import SnsClient
import URLRouting
import VerifyReceiptMiddleware

@MemberwiseInit(.public)
public struct ServerEnvironment {
  public var changelog: () -> Changelog
  public var database: DatabaseClient
  public var date: () -> Date
  public var dictionary: DictionaryClient
  public var envVars: EnvVars
  public var itunes: ItunesClient
  public var mailgun: MailgunClient
  public var randomCubes: () -> ArchivablePuzzle
  public var router: ServerRouter
  public var snsClient: SnsClient
}

#if DEBUG
  import XCTestDynamicOverlay

  extension ServerEnvironment {
    public static let testValue = Self(
      changelog: unimplemented("\(Self.self).changelog", placeholder: .current),
      database: .testValue,
      date: unimplemented("\(Self.self).date", placeholder: Date()),
      dictionary: .testValue,
      envVars: EnvVars(appEnv: .testing),
      itunes: .testValue,
      mailgun: .testValue,
      randomCubes: unimplemented("\(Self.self).randomCubes", placeholder: .mock),
      router: .testValue,
      snsClient: .testValue
    )
  }
#endif
