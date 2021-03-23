import SwiftUI

/// Adaptive `HStack`.
///
/// A view that arranges its children in a horizontal line by default, and
/// in a vertical line when:  the environment `sizeCategory` is among the
/// accessibility ones OR when the `horizontalSizeClass` is `.compact`
public struct AHStack<Content: View>: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  /// The content of this stack.
  var content: Content

  /// `HStack` alignment.
  var horizontalStackAlignment: VerticalAlignment
  /// `HStack` spacing.
  var horizontalStackSpacing: CGFloat?
  /// `VStack` alignment.
  var verticalStackAlignment: HorizontalAlignment
  /// `VStack` spacing.
  var verticalStackSpacing: CGFloat?
  /// What we're observing to decide if we should adapt.
  var observing: AStackOptions

  /// Creates an instance with the given horizontal and vertical spacing and
  /// axes alignment.
  ///
  /// - Parameters:
  ///   - observing: The @Environment values used to determine when we should
  ///     adapt. Currently, either `sizeCategory`, `sizeClass`, or both.
  ///   - horizontalStackAlignment: The guide that will have the same horizontal
  ///     screen coordinate for all children.
  ///   - horizontalStackSpacing: The distance between adjacent children, or
  ///     `nil` if the stack should choose a default distance for each pair of
  ///     children.
  ///   - verticalStackAlignment: The guide that will have the same horizontal
  ///     screen coordinate for all children.
  ///   - verticalStackSpacing: The distance between adjacent children, or `nil`
  ///     if the stack should choose a default distance for each pair of
  ///     children.
  ///   - content: A `View` that describes the purpose of the instance.
  public init(
    observing: AStackOptions = .sizeCategory,
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.observing = observing
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.content = content()
  }

  var shouldAdapt: Bool {
    switch observing {
    case [.sizeCategory, .sizeClass]:
      return sizeCategory.isAccessibility || horizontalSizeClass == .compact
    case .sizeCategory:
      return sizeCategory.isAccessibility
    case .sizeClass:
      return horizontalSizeClass == .compact
    case []:
      return false // Never adapt
    default: fatalError() // should never happen
    }
  }

  @ViewBuilder
  public var body: some View {
    if shouldAdapt {
      VStack(
        alignment: verticalStackAlignment,
        spacing: verticalStackSpacing
      ) {
        content
      }
    } else {
      HStack(
        alignment: horizontalStackAlignment,
        spacing: horizontalStackSpacing
      ) {
        content
      }
    }
  }
}
