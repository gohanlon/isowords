import MemberwiseInit
import SharedModels

@MemberwiseInit(.public)
public struct DictionaryClient {
  public var contains: (String, Language) -> Bool
  public var load: (Language) throws -> Bool
  public var lookup: ((String, Language) -> Lookup?)?
  public var randomCubes: (Language) -> Puzzle
  public var unload: (Language) -> Void

  public enum Lookup: Equatable {
    case prefix
    case word
  }
}
