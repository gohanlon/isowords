import MemberwiseInit

public struct CreatePlatformEndpointResponse: Decodable {
  public let response: Response

  private enum CodingKeys: String, CodingKey {
    case response = "CreatePlatformEndpointResponse"
  }

  public struct Response: Decodable {
    public let result: Result

    private enum CodingKeys: String, CodingKey {
      case result = "CreatePlatformEndpointResult"
    }

    public struct Result: Decodable {
      public let endpointArn: String

      private enum CodingKeys: String, CodingKey {
        case endpointArn = "EndpointArn"
      }
    }
  }
}

public struct DeleteEndpointResponse: Decodable {
  public let response: Response

  private enum CodingKeys: String, CodingKey {
    case response = "DeleteEndpointResponse"
  }

  public struct Response: Decodable {
  }
}

@MemberwiseInit(.public)
public struct PublishResponse: Decodable {
  public let response: Response

  private enum CodingKeys: String, CodingKey {
    case response = "PublishResponse"
  }

  @MemberwiseInit(.public)
  public struct Response: Decodable {
    public let result: Result

    private enum CodingKeys: String, CodingKey {
      case result = "PublishResult"
    }

    @MemberwiseInit(.public)
    public struct Result: Decodable {
      public let messageId: String

      private enum CodingKeys: String, CodingKey {
        case messageId = "MessageId"
      }
    }
  }
}

public struct AwsError: Decodable, Swift.Error {
  public let error: Error
  public let requestId: String

  private enum CodingKeys: String, CodingKey {
    case error = "Error"
    case requestId = "RequestId"
  }

  public struct Error: Decodable {
    public let code: String
    public let message: String
    public let type: String

    private enum CodingKeys: String, CodingKey {
      case code = "Code"
      case message = "Message"
      case type = "Type"
    }
  }
}
