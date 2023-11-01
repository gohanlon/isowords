import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct ResultEnvelope: Equatable {
  public var outOf: Int = 0
  public var results: [Result] = []

  @MemberwiseInit(.public)
  public struct Result: Equatable, Identifiable {
    public var denseRank: Int
    public var id: UUID
    public var isYourScore: Bool = false
    public var rank: Int
    public var score: Int
    public var subtitle: String? = nil
    public var title: String
  }

  public var contiguousResults: ArraySlice<Result> {
    for (index, prevIndex) in zip(self.results.indices.dropFirst(), self.results.indices) {
      if self.results[index].denseRank - self.results[prevIndex].denseRank > 1 {
        return self.results[self.results.startIndex..<index]
      }
    }
    return self.results[...]
  }

  public var nonContiguousResult: Result? {
    guard self.results.count >= 2
    else { return nil }

    let lastIndex = self.results.count - 1
    if self.results[lastIndex].denseRank - self.results[lastIndex - 1].denseRank > 1 {
      return self.results.last
    } else {
      return nil
    }
  }
}
