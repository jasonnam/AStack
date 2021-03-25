import Foundation

/// Options that enable AStack to determine when to adapt/switch axis.
public struct ObservingOptions: OptionSet {
  public let rawValue: Int

  /// Initializes an `ObservingOptions` object.
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  /// Observes the `.sizeCategory` environment value.
  public static let sizeCategory = ObservingOptions(rawValue: 1 << 0)

  /// Observes the `.sizeClass` environment value.
  ///
  /// Either `.horizontalSizeClass` or `.verticalSizeClass`, based on the stack.
  public static let sizeClass = ObservingOptions(rawValue: 1 << 1)
}
