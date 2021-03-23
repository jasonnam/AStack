import SwiftUI

#if swift(>=5.3)

/// Adaptive `LazyVStack`.
///
/// A view that arranges its children in a line, creating items only as needed.
/// The line grows vertically by default, and switches to horizontal when the
/// environment `sizeCategory` is among the accessibility ones OR
/// when the `verticalSizeClass` is `.compact`.
@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
public struct LazyAVStack<Content: View>: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  @Environment(\.verticalSizeClass) var verticalSizeClass

  /// What we're observing to decide if we should adapt.
  let observing: AStackOptions

  /// `LazyHStack` alignment.
  let horizontalStackAlignment: VerticalAlignment

  /// `LazyHStack` spacing.
  let horizontalStackSpacing: CGFloat?

  /// `LazyHStack` pinned views.
  let horizontalStackPinnedViews: PinnedScrollableViews

  /// `LazyVStack` alignment.
  let verticalStackAlignment: HorizontalAlignment

  /// `LazyVStack` spacing.
  let verticalStackSpacing: CGFloat?

  /// `LazyVStack` pinned views.
  let verticalStackPinnedViews: PinnedScrollableViews

  /// The content of this stack.
  let content: Content

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
  ///   - verticalStackPinnedViews: The kinds of child views that will be
  ///     pinned.
  ///   - horizontalStackAlignment: The guide that will have the same horizontal
  ///     screen coordinate for all children.
  ///   - horizontalStackSpacing: The distance between adjacent children, or
  ///     `nil` if the stack should choose a default distance for each pair of
  ///     children.
  ///   - horizontalStackPinnedViews: The kinds of child views that will be
  ///     pinned.
  ///   - content: A `View` that describes the purpose of the instance.
  public init(
    observing: AStackOptions = .sizeCategory,
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    vPinnedViews verticalStackPinnedViews: PinnedScrollableViews = .init(),
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    hPinnedViews horizontalStackPinnedViews: PinnedScrollableViews = .init(),
    @ViewBuilder content: () -> Content
  ) {
    self.observing = observing
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.verticalStackPinnedViews = verticalStackPinnedViews
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.horizontalStackPinnedViews = horizontalStackPinnedViews
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
      LazyHStack(
        alignment: horizontalStackAlignment,
        spacing: horizontalStackSpacing,
        pinnedViews: horizontalStackPinnedViews
      ) {
        content
      }
    } else {
      LazyVStack(
        alignment: verticalStackAlignment,
        spacing: verticalStackSpacing,
        pinnedViews: verticalStackPinnedViews
      ) {
        content
      }
    }
  }
}

#endif
