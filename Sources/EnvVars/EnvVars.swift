import Foundation
import MemberwiseInit
import SnsClient
import Tagged

@MemberwiseInit(.public)
public struct EnvVars: Codable {
  public var appEnv: AppEnv = .development
  public var awsAccessKeyId: String = "blank-aws-access-key-id"
  public var awsPlatformApplicationArn: PlatformArn =
    "arn:aws:sns:us-east-1:1234567890:app/APNS/deadbeef"
  public var awsPlatformApplicationSandboxArn: PlatformArn =
    "arn:aws:sns:us-east-1:1234567890:app/APNS_SANDBOX/deadbeef"
  public var awsSecretKey: String = "blank-aws-secret-key"
  public var baseUrl: URL = URL(string: "http://localhost:9876")!
  public var databaseUrl: String = "postgres://isowords:@localhost:5432/isowords_development"
  public var mailgunApiKey: String = "blank-mailgun-api-key"
  public var mailgunDomain: String = "blank-mailgun-domain"
  public var port: String = "9876"
  @Init(.public, label: "secrets") var _secrets: String = "deadbeef"

  private enum CodingKeys: String, CodingKey {
    case appEnv = "APP_ENV"
    case awsAccessKeyId = "AWS_ACCESS_KEY_ID"
    case awsPlatformApplicationArn = "AWS_PLATFORM_APPLICATION_ARN"
    case awsPlatformApplicationSandboxArn = "AWS_PLATFORM_APPLICATION_SANDBOX_ARN"
    case awsSecretKey = "AWS_SECRET_KEY"
    case databaseUrl = "DATABASE_URL"
    case baseUrl = "BASE_URL"
    case mailgunApiKey = "MAILGUN_API_KEY"
    case mailgunDomain = "MAILGUN_DOMAIN"
    case port = "PORT"
    case _secrets = "SECRETS"
  }

  public enum AppEnv: String, Codable {
    case development
    case production
    case staging
    case testing
  }

  public var secrets: [String] {
    self._secrets.split(separator: ",").map(String.init)
  }
}
