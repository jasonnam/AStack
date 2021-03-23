//

import SwiftUI

/// These definitions are required as macOS, watchOS, tvOS don't have
/// `horizontalSizeClass` and `verticalSizeClass` environment values.
///
/// As a workaround, we default their value to `.regular` (a.k.a. they won't
/// trigger the stack to switch axis).

#if os(macOS) || os(tvOS) || os(watchOS)
enum UserInterfaceSizeClass {
  case compact
  case regular
}

struct HorizontalSizeClassEnvironmentKey: EnvironmentKey {
  static let defaultValue: UserInterfaceSizeClass = .regular
}

struct VerticalSizeClassEnvironmentKey: EnvironmentKey {
  static let defaultValue: UserInterfaceSizeClass = .regular
}

extension EnvironmentValues {
  var horizontalSizeClass: UserInterfaceSizeClass {
    get { return self[HorizontalSizeClassEnvironmentKey] }
    set { self[HorizontalSizeClassEnvironmentKey] = newValue }
  }
  var verticalSizeClass: UserInterfaceSizeClass {
    get { return self[VerticalSizeClassEnvironmentKey] }
    set { self[VerticalSizeClassEnvironmentKey] = newValue }
  }
}
#endif
