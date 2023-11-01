import MemberwiseInit

@MemberwiseInit(.public)
public struct AnyComparable: Comparable {
  public let base: Any
  @Init(.public) let isEqual: (Any) -> Bool
  @Init(.public) let compare: (Any) -> Bool

  public init<C: Equatable>(_ base: C, compare: @escaping (C, C) -> Bool) {
    self.base = base
    self.isEqual = { other in
      (other as? C) == base
    }
    self.compare = { other in
      (other as? C).map { compare(base, $0) } ?? false
    }
  }

  public init<C: Comparable>(_ base: C) {
    self.base = base
    self.isEqual = { other in
      (other as? C) == base
    }
    self.compare = { other in
      (other as? C).map { base < $0 } ?? false
    }
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.isEqual(rhs.base)
  }

  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.compare(rhs.base)
  }

  public var reversed: Self {
    .init(base: self.base, isEqual: self.isEqual, compare: { !self.compare($0) })
  }
}
