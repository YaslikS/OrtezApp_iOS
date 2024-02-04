//
//  Double+Extensions.swift
//  OrtezApp
//
//  Created by Maxim Vekovenko on 21.06.2022.
//

import UIKit

extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
