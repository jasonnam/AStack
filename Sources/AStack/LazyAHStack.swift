import SwiftUI

#if swift(>=5.3)

/// Adaptive `LazyHStack`.
///
/// A view that arranges its children in a line, creating items only as needed.
/// The line grows horizontally by default, and switches to vertical when the
/// environment `sizeCategory` is among the accessibility ones OR
/// when the `horizontalSizeClass` is `.compact`.
@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
public struct LazyAHStack<Content: View>: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  /// A view builder that creates the content of this stack.
  var content: () -> Content

  /// `LazyHStack` aligment.
  var horizontalStackAlignment: VerticalAlignment
  /// `LazyHStack` spacing.
  var horizontalStackSpacing: CGFloat?
  /// `LazyHStack` pinned views.
  var horizontalStackPinnedViews: PinnedScrollableViews
  /// `LazyVStack` aligment.
  var verticalStackAlignment: HorizontalAlignment
  /// `LazyVStack` spacing.
  var verticalStackSpacing: CGFloat?
  /// `LazyVStack` pinned views.
  var verticalStackPinnedViews: PinnedScrollableViews

  /// Creates an instance with the given horizontal and vertical spacing and
  /// axes alignment.
  ///
  /// - Parameters:
  ///   - horizontalStackAlignment: The guide that will have the same horizontal
  ///     screen coordinate for all children.
  ///   - horizontalStackSpacing: The distance between adjacent children, or
  ///     `nil` if the stack should choose a default distance for each pair of
  ///     children.
  ///   - horizontalStackPinnedViews: The kinds of child views that will be
  ///     pinned.
  ///   - verticalStackAlignment: The guide that will have the same horizontal
  ///     screen coordinate for all children.
  ///   - verticalStackSpacing: The distance between adjacent children, or `nil`
  ///     if the stack should choose a default distance for each pair of
  ///     children.
  ///   - verticalStackPinnedViews: The kinds of child views that will be
  ///     pinned.
  ///   - content: A view builder that creates the content of this stack.
  public init(
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    hPinnedViews horizontalStackPinnedViews: PinnedScrollableViews = .init(),
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    vPinnedViews verticalStackPinnedViews: PinnedScrollableViews = .init(),
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.horizontalStackPinnedViews = horizontalStackPinnedViews
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.verticalStackPinnedViews = verticalStackPinnedViews
    self.content = content
  }

  @ViewBuilder
  public var body: some View {
    if sizeCategory.isAccessibilityCategory || horizontalSizeClass == .compact {
      LazyVStack(
        alignment: verticalStackAlignment,
        spacing: verticalStackSpacing,
        pinnedViews: verticalStackPinnedViews
      ) {
        self.content()
      }
    } else {
      LazyHStack(
        alignment: horizontalStackAlignment,
        spacing: horizontalStackSpacing,
        pinnedViews: horizontalStackPinnedViews
      ) {
        self.content()
      }
    }
  }
}

#endif
