import SwiftUI

/// A view that arranges its children in a horizontal line by default, and
/// in a vertical line when the environment `sizeCategory` is among the
/// accessibility ones.
public struct AHStack<Content>: View where Content: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  var content: () -> Content

  // Horizontal details.
  var horizontalStackAlignment: VerticalAlignment
  var horizontalStackSpacing: CGFloat?
  // Vertical details.
  var verticalStackAlignment: HorizontalAlignment
  var verticalStackSpacing: CGFloat?

  /// Creates an instance with the given horizontal and vertical spacing and
  /// axes alignment.
  ///
  /// - Parameters:
  ///   - hAlignment: The guide that will have the same horizontal screen
  ///     coordinate for all children.
  ///   - hSpacing: The distance between adjacent children, or nil if the stack
  ///     should choose a default distance for each pair of children.
  ///   - vAlignment: The guide that will have the same horizontal screen
  ///     coordinate for all children.
  ///   - vSpacing: The distance between adjacent children, or nil if the stack
  ///     should choose a default distance for each pair of children.
  public init(
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.content = content
  }

  public var body: some View {
    if sizeCategory.isAccessibility {
      return AnyView(
        VStack(
          alignment: verticalStackAlignment,
          spacing: verticalStackSpacing
        ) {
          self.content()
        }
      )
    } else {
      return AnyView(
        HStack(
          alignment: horizontalStackAlignment,
          spacing: horizontalStackSpacing
        ) {
          self.content()
        }
      )
    }
  }
}
