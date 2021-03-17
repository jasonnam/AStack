import SwiftUI

/// Adaptive `HStack`.
///
/// A view that arranges its children in a horizontal line by default, and
/// in a vertical line when:  the environment `sizeCategory` is among the
/// accessibility ones OR when the `horizontalSizeClass` is `.compact`
public struct AHStack<Content: View>: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  /// A view builder that creates the content of this stack.
  var content: () -> Content

  /// `HStack` aligment.
  var horizontalStackAlignment: VerticalAlignment
  /// `HStack` spacing.
  var horizontalStackSpacing: CGFloat?
  /// `VStack` aligment.
  var verticalStackAlignment: HorizontalAlignment
  /// `VStack` spacing.
  var verticalStackSpacing: CGFloat?
  /// What we're observing to decide if we should adapt.
  var observing: AStackOptions

  /// Creates an instance with the given horizontal and vertical spacing and
  /// axes alignment.
  ///
  /// - Parameters:
  ///   - observing: The @Environment value that we are observing to determine if we should adapt. Currently, either the `sizeCategory`, `horizontalSizeClass`, or both.
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
    observing: AStackOptions = .horizontalSizeClass,
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.observing = observing
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.content = content
  }
  
  var willAdapt: Bool {
    switch observing {
    case [.sizeCategory, .horizontalSizeClass]:
      return sizeCategory.isAccessibility || horizontalSizeClass == .compact
    case .sizeCategory:
      return sizeCategory.isAccessibility
    case .horizontalSizeClass:
      return horizontalSizeClass == .compact
    case []:
      return false // Never adapt
    default: fatalError() // should never happen
    }
  }

  @ViewBuilder
  public var body: some View {
    if  willAdapt {
      VStack(
        alignment: verticalStackAlignment,
        spacing: verticalStackSpacing
      ) {
        self.content()
      }
    } else {
      HStack(
        alignment: horizontalStackAlignment,
        spacing: horizontalStackSpacing
      ) {
        self.content()
      }
    }
  }
}


