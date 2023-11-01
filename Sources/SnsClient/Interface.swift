import Either
import MemberwiseInit
import Tagged

public typealias EndpointArn = Tagged<((), endpointArn: ()), String>
public typealias PlatformArn = Tagged<((), platformArn: ()), String>

@MemberwiseInit(.public)
public struct SnsClient {
  public var createPlatformEndpoint:
    (CreatePlatformRequest) -> EitherIO<Error, CreatePlatformEndpointResponse>
  public var deleteEndpoint: (EndpointArn) -> EitherIO<Error, DeleteEndpointResponse>
  @Init(label: "publish") public var _publish:
    (_ targetArn: EndpointArn, _ payload: AnyEncodable) -> EitherIO<Error, PublishResponse>

  public func publish<Content: Encodable>(
    targetArn: EndpointArn,
    payload: ApsPayload<Content>
  ) -> EitherIO<Error, PublishResponse> {
    self._publish(targetArn, AnyEncodable(payload))
  }

  @MemberwiseInit(.public)
  public struct CreatePlatformRequest: Equatable {
    public let apnsToken: String
    public let platformApplicationArn: PlatformArn
  }
}
