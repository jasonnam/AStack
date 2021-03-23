import SwiftUI

/// Adaptive `VStack`.
///
/// A view that arranges its children in a vertical line by default, and
/// in a horizontal line when:  the environment `sizeCategory` is among the
/// accessibility ones OR when the `verticalSizeClass` is `.compact`
public struct AVStack<Content: View>: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  @Environment(\.verticalSizeClass) var verticalSizeClass

  /// What we're observing to decide if we should adapt.
  let observing: AStackOptions

  /// `HStack` alignment.
  let horizontalStackAlignment: VerticalAlignment

  /// `HStack` spacing.
  let horizontalStackSpacing: CGFloat?

  /// `VStack` alignment.
  let verticalStackAlignment: HorizontalAlignment

  /// `VStack` spacing.
  let verticalStackSpacing: CGFloat?
  
  /// The content of this stack.
  let content: Content

  /// Creates an instance with the given vertical and horizontal spacing and
  /// axes alignment.
  ///
  /// - Parameters:
  ///   - observing: The @Environment values used to determine when we should
  ///     adapt. Currently `sizeCategory` and/or `sizeClass`.
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

  /// Whether this stack should switch axis (a.k.a 'adapt') or not.
  var shouldAdapt: Bool {
    observing.contains(.sizeCategory) && sizeCategory.isAccessibility ||
    observing.contains(.sizeClass) && verticalSizeClass == .compact
  }

  @ViewBuilder
  public var body: some View {
    if shouldAdapt {
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
