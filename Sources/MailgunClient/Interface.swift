import Either
import MemberwiseInit
import Tagged

public typealias EmailAddress = Tagged<((), email: ()), String>

public struct MailgunClient {
  public var sendEmail: (EmailData) -> EitherIO<Error, SendEmailResponse>
}

@MemberwiseInit(.public)
public struct EmailData {
  public var from: EmailAddress
  public var to: EmailAddress
  public var subject: String
  public var text: String
}

@MemberwiseInit(.public)
public struct SendEmailResponse: Decodable {
  public typealias Id = Tagged<Self, String>

  public let id: Id
  public let message: String
}
