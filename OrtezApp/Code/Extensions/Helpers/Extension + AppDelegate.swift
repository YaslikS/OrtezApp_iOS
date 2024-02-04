//
//  Extension + AppDelegate.swift
//  OrtezApp
//
//  Created by Александр Александрович on 11.08.2022.
//

import UIKit

extension AppDelegate {
   static var shared: AppDelegate {
      return UIApplication.shared.delegate as! AppDelegate
   }
}
