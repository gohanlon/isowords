import ComposableArchitecture
import Gen
import MemberwiseInit
import Styleguide
import SwiftUI

@MemberwiseInit(.public)
public struct Bloom: Identifiable {
  public let color: UIColor
  @Init(default: UUID()) public let id: UUID
  public let index: Int
  public let size: CGFloat
  public let offset: CGPoint
}

@MemberwiseInit(.public)
public struct Blooms: View {
  public let blooms: [Bloom]

  public var body: some View {
    ZStack {
      ForEach(self.blooms) { bloom in
        Rectangle()
          .fill(
            RadialGradient(
              gradient: Gradient(
                colors: [
                  Color(bloom.color),
                  Color(bloom.color).opacity(0),
                ]
              ),
              center: .center,
              startRadius: 0,
              endRadius: bloom.size / 2
            )
          )
          .frame(width: bloom.size, height: bloom.size)
          .offset(x: bloom.offset.x, y: bloom.offset.y)
          .transition(
            .asymmetric(
              insertion: .opacity,
              removal: AnyTransition.opacity.animation(
                .easeInOut(duration: (1 - Double(bloom.index) / Double(self.blooms.count)))
              )
            )
          )
          .zIndex(Double(bloom.index))
      }
    }
  }
}

public struct BloomBackground: View {
  @MemberwiseInit(.public)
  public struct ViewState: Equatable {
    @Init(.public) let bloomCount: Int
    @Init(.public) let word: String
  }

  @State var blooms: [Bloom] = []
  @Environment(\.colorScheme) var colorScheme
  let size: CGSize
  let store: Store<ViewState, Never>
  @State var vertexGenerator: AnyIterator<CGPoint> = {
    var rng = Xoshiro(seed: 0)
    var vertices: [CGPoint] = [
      .init(x: 0.04, y: 0.04),
      .init(x: 0.04, y: -0.04),
      .init(x: -0.04, y: -0.04),
      .init(x: -0.04, y: 0.04),
    ]
    var index = 0
    return AnyIterator {
      defer { index += 1 }
      if index % vertices.count == 0 {
        vertices.shuffle(using: &rng)
      }
      return vertices[index % vertices.count]
    }
  }()
  @ObservedObject var viewStore: ViewStore<ViewState, Never>

  public init(size: CGSize, store: Store<ViewState, Never>) {
    self.size = size
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }

  public var body: some View {
    Blooms(blooms: self.blooms)
      .onChange(of: self.viewStore.bloomCount) { count in
        withAnimation(.easeOut(duration: 1)) {
          self.renderBlooms(count: count)
        }
      }
      .onAppear { self.renderBlooms(count: self.viewStore.bloomCount) }
  }

  func renderBlooms(count: Int) {
    if count > self.blooms.count {
      let colors =
        Styleguide.letterColors.first { key, _ in
          key.contains(self.viewStore.word)
        }?
        .value ?? []
      guard colors.count > 0
      else { return }
      (self.blooms.count..<count).forEach { index in
        let color = colors[index % colors.count]
          .withAlphaComponent(self.colorScheme == .dark ? 0.5 : 1)
        var vertex = vertexGenerator.next()!
        let width = self.size.width * 1.2
        let height = self.size.height * 0.85
        vertex.x *= CGFloat(index) * width
        vertex.y *= CGFloat(index) * height
        let size = (1 + CGFloat(index) * 0.1) * width

        let bloom = Bloom(
          color: color,
          index: self.blooms.count,
          size: size,
          offset: vertex
        )
        self.blooms.append(bloom)
      }
    } else {
      self.blooms.removeLast(self.blooms.count - count)
    }
  }
}
