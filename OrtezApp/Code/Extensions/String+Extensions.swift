//
//  String+Extensions.swift
//  OrtezApp
//
//  Created by Maxim Vekovenko on 08.06.2022.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
