import SwiftUI

/// Adaptive `VStack`.
///
/// A view that arranges its children in a vertical line by default, and
/// in a horizontal line when the environment `sizeCategory` is among the
/// accessibility ones.
public struct AVStack<Content>: View where Content: View {
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

  public var body: some View {
    if sizeCategory.isAccessibility {
      return AnyView(
        HStack(
          alignment: horizontalStackAlignment,
          spacing: horizontalStackSpacing
        ) {
          self.content()
        }
      )
    } else {
      return AnyView(
        VStack(
          alignment: verticalStackAlignment,
          spacing: verticalStackSpacing
        ) {
          self.content()
        }
      )
    }
  }
}
