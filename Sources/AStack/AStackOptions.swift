import Foundation

public struct AStackOptions: OptionSet {
  public let rawValue: Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  public static let sizeCategory = AStackOptions(rawValue: 1 << 0)
  public static let sizeClass = AStackOptions(rawValue: 1 << 1)
  public static let none: AStackOptions = []
}
