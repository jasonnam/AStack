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
  /// What we're observing to decide if we should adapt.
  var observing: AStackOptions

  /// Creates an instance with the given vertical and horizontal spacing and
  /// axes alignment.
  ///
  /// - Parameters:
  /// - observing: The @Environment value that we are observing to determine if we should adapt. Currently, either the `sizeCategory`, `verticalSizeClass`, or both.
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
    observing: AStackOptions = .sizeClass,
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    vPinnedViews verticalStackPinnedViews: PinnedScrollableViews = .init(),
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    hPinnedViews horizontalStackPinnedViews: PinnedScrollableViews = .init(),
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.observing = observing
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.verticalStackPinnedViews = verticalStackPinnedViews
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.horizontalStackPinnedViews = horizontalStackPinnedViews
    self.content = content
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
      LazyHStack(
        alignment: horizontalStackAlignment,
        spacing: horizontalStackSpacing,
        pinnedViews: horizontalStackPinnedViews
      ) {
        self.content()
      }
    } else {
      LazyVStack(
        alignment: verticalStackAlignment,
        spacing: verticalStackSpacing,
        pinnedViews: verticalStackPinnedViews
      ) {
        self.content()
      }
    }
  }
}

#endif
