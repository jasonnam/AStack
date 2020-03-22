import SwiftUI

/// A view that arranges its children in a horizontal line by default, and
/// in a vertical line when the environment `sizeCategory` is among the
/// accessibility ones.
public struct AHStack<Content>: View where Content: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  var content: () -> Content

  // Horizontal details.
  var horizontalAlignment: HorizontalAlignment
  var horizontalSpacing: CGFloat?
  // Vertical details.
  var verticalAlignment: VerticalAlignment
  var verticalSpacing: CGFloat?

  /// Creates an instance with the given horizontal and vertical spacing and
  /// axes alignment.
  ///
  /// - Parameters:
  ///   - hAlignment: the guide that will have the same horizontal screen
  ///     coordinate for all children.
  ///   - hSpacing: the distance between adjacent children, or nil if the stack
  ///     should choose a default distance for each pair of children.
  ///   - vAlignment: the guide that will have the same horizontal screen
  ///     coordinate for all children.
  ///   - vSpacing: the distance between adjacent children, or nil if the stack
  ///     should choose a default distance for each pair of children.
  public init(
    hAlignment horizontalAlignment: HorizontalAlignment = .center,
    hSpacing horizontalSpacing: CGFloat? = nil,
    vAlignment verticalAlignment: VerticalAlignment = .center,
    vSpacing verticalSpacing: CGFloat? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.horizontalAlignment = horizontalAlignment
    self.horizontalSpacing = horizontalSpacing
    self.verticalAlignment = verticalAlignment
    self.verticalSpacing = verticalSpacing
    self.content = content
  }

  public var body: some View {
    if sizeCategory.isAccessibility {
      return AnyView(
        VStack(
          alignment: horizontalAlignment,
          spacing: horizontalSpacing
        ) {
          self.content()
        }
      )
    } else {
      return AnyView(
        HStack(
          alignment: verticalAlignment,
          spacing: verticalSpacing
        ) {
          self.content()
        }
      )
    }
  }
}
