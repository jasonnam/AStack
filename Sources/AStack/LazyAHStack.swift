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

  /// The content of this stack.
  var content: Content

  /// `LazyHStack` alignment.
  var horizontalStackAlignment: VerticalAlignment
  /// `LazyHStack` spacing.
  var horizontalStackSpacing: CGFloat?
  /// `LazyHStack` pinned views.
  var horizontalStackPinnedViews: PinnedScrollableViews
  /// `LazyVStack` alignment.
  var verticalStackAlignment: HorizontalAlignment
  /// `LazyVStack` spacing.
  var verticalStackSpacing: CGFloat?
  /// `LazyVStack` pinned views.
  var verticalStackPinnedViews: PinnedScrollableViews
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
    observing: AStackOptions = .sizeCategory,
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    hPinnedViews horizontalStackPinnedViews: PinnedScrollableViews = .init(),
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    vPinnedViews verticalStackPinnedViews: PinnedScrollableViews = .init(),
    @ViewBuilder content: () -> Content
  ) {
    self.observing = observing
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.horizontalStackPinnedViews = horizontalStackPinnedViews
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.verticalStackPinnedViews = verticalStackPinnedViews
    self.content = content()
  }
  
  var willAdapt: Bool {
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
    if willAdapt {
      LazyVStack(
        alignment: verticalStackAlignment,
        spacing: verticalStackSpacing,
        pinnedViews: verticalStackPinnedViews
      ) {
        content
      }
    } else {
      LazyHStack(
        alignment: horizontalStackAlignment,
        spacing: horizontalStackSpacing,
        pinnedViews: horizontalStackPinnedViews
      ) {
        content
      }
    }
  }
}

#endif
