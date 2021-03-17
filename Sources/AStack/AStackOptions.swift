//
//  File.swift
//  
//
//  Created by Daniel Lyons on 3/17/21.
//

import Foundation

public struct AStackOptions: OptionSet {
  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public static let sizeCategory = AStackOptions(rawValue: 1 << 0)
  public static let horizontalSizeClass = AStackOptions(rawValue: 1 << 1)
  public static let verticalSizeClass = AStackOptions(rawValue: 1 << 2)
  public static let none: AStackOptions = []
}
