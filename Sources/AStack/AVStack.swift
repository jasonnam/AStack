import SwiftUI

/// Adaptive `VStack`.
///
/// A view that arranges its children in a vertical line by default, and
/// in a horizontal line when:  the environment `sizeCategory` is among the
/// accessibility ones OR when the `verticalSizeClass` is `.compact`
public struct AVStack<Content: View>: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  @Environment(\.verticalSizeClass) var verticalSizeClass

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

  /// Creates an instance with the given vertical and horizontal spacing and
  /// axes alignment.
  ///
  /// - Parameters:
  ///   - observing: The @Environment values used to determine when we should
  ///     adapt. Currently, either `sizeCategory`, `sizeClass`, or both.
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
    observing: AStackOptions = .sizeCategory,
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.observing = observing
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.content = content()
  }
  
  var willAdapt: Bool {
    switch observing {
    case [.sizeCategory, .sizeClass]:
      return sizeCategory.isAccessibility || verticalSizeClass == .compact
    case .sizeCategory:
      return sizeCategory.isAccessibility
    case .sizeClass:
      return verticalSizeClass == .compact
    case []:
      return false // Never adapt
    default: fatalError() // should never happen
    }
  }

  @ViewBuilder
  public var body: some View {
    if willAdapt {
      HStack(
        alignment: horizontalStackAlignment,
        spacing: horizontalStackSpacing
      ) {
        content
      }
    } else {
      VStack(
        alignment: verticalStackAlignment,
        spacing: verticalStackSpacing
      ) {
        content
      }
    }
  }
}
