import MemberwiseInit

public struct NoContent: Codable, Equatable {}

@MemberwiseInit(.public)
public struct ApsPayload<Content> {
  public let aps: Aps
  public let content: Content

  private enum CodingKeys: String, CodingKey {
    case aps
  }

  @MemberwiseInit(.public)
  public struct Aps: Codable, Equatable {
    public let alert: Alert
    public let badge: Int? = nil
    public let contentAvailable: Bool? = nil

    private enum CodingKeys: String, CodingKey {
      case alert
      case badge
      case contentAvailable = "content-available"
    }

    @MemberwiseInit(.public)
    public struct Alert: Codable, Equatable {
      @Init(default: nil) public let actionLocalizedKey: String?
      @Init(default: nil) public let body: String?
      @Init(default: nil) public let localizedArguments: [String]?
      @Init(default: nil) public let localizedKey: String?
      @Init(default: nil) public let sound: String?
      @Init(default: nil) public let title: String?

      private enum CodingKeys: String, CodingKey {
        case actionLocalizedKey = "action-loc-key"
        case body
        case localizedArguments = "loc-args"
        case localizedKey = "loc-key"
        case sound
        case title
      }
    }
  }
}

extension ApsPayload where Content == NoContent {
  public init(aps: Aps) {
    self.aps = aps
    self.content = NoContent()
  }
}

extension ApsPayload: Equatable where Content: Equatable {}

extension ApsPayload: Decodable where Content: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.aps = try container.decode(Aps.self, forKey: .aps)
    self.content = try Content(from: decoder)
  }
}

extension ApsPayload: Encodable where Content: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.aps, forKey: .aps)
    try self.content.encode(to: encoder)
  }
}
