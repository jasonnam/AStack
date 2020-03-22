import SwiftUI

extension ContentSizeCategory {
  /// A `Bool` value indicating whether the content size category is one that
  /// is associated with accessibility.
  var isAccessibility: Bool {
    if #available(iOS 13.4, OSX 10.15.4, tvOS 13.4, watchOS 6.2, *) {
      return isAccessibilityCategory
    }
    return Self.accessibilityCategories.contains(self)
  }

  /// A set containing all accessibility content size categories.
  private static let accessibilityCategories: Set<ContentSizeCategory> = [
    .accessibilityMedium,
    .accessibilityLarge,
    .accessibilityExtraLarge,
    .accessibilityExtraExtraLarge,
    .accessibilityExtraExtraExtraLarge
  ]
}
