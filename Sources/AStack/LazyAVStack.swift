import SwiftUI

/// Adaptive `LazyVStack`.
///
/// A view that arranges its children in a line, creating items only as needed.
/// The line grows vertically by default, and switches to horizontal when the
/// environment `sizeCategory` is among the accessibility ones.
@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
public struct LazyAVStack<Content: View>: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

  /// A `View` that describes the purpose of the instance.
  var content: () -> Content

  /// `HStack` aligment.
  var horizontalStackAlignment: VerticalAlignment
  /// `HStack` spacing.
  var horizontalStackSpacing: CGFloat?
  /// `VStack` aligment.
  var verticalStackAlignment: HorizontalAlignment
  /// `VStack` spacing.
  var verticalStackSpacing: CGFloat?

  /// Creates an instance with the given vertical and horizontal spacing and
  /// axes alignment.
  ///
  /// - Parameters:
  ///   - verticalStackAlignment: The guide that will have the same horizontal
  ///     screen coordinate for all children.
  ///   - verticalStackSpacing: The distance between adjacent children, or `nil`
  ///     if the stack should choose a default distance for each pair of
  ///     children.
  ///   - horizontalStackAlignment: The guide that will have the same horizontal
  ///     screen coordinate for all children.
  ///   - horizontalStackSpacing: The distance between adjacent children, or
  ///     `nil` if the stack should choose a default distance for each pair of
  ///     children.
  ///   - content: A `View` that describes the purpose of the instance.
  public init(
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.content = content
  }

  @ViewBuilder
  public var body: some View {
    if sizeCategory.isAccessibility {
      LazyHStack(
        alignment: horizontalStackAlignment,
        spacing: horizontalStackSpacing
      ) {
        self.content()
      }
    } else {
      LazyVStack(
        alignment: verticalStackAlignment,
        spacing: verticalStackSpacing
      ) {
        self.content()
      }
    }
  }
}
