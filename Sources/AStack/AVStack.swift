import SwiftUI

/// Adaptive `VStack`.
///
/// A view that arranges its children in a vertical line by default, and
/// switches to horizontal based on the observed environment values:
/// - if `.sizeCategory` is observed, the switch happens when its value is among
///   the accessibility ones.
/// - if `.sizeClass` is observed, the switch happens when the
///   `verticalSizeClass` value is `.compact`.
/// - if both are observed, the switch happens when at least one of the above is
///   true.
/// - if neither is observed, the switch never happens.
public struct AVStack<Content: View>: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  @Environment(\.verticalSizeClass) var verticalSizeClass

  /// What the view observes to decide when to adapt.
  let observing: ObservingOptions

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
  ///   - observing: The @Environment values used to determine when the view
  ///     should adapt. Currently `sizeCategory` and/or `sizeClass`.
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
    observing: ObservingOptions = .sizeCategory,
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
