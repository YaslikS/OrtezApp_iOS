//
//  DeviceList.swift
//  OrtezApp
//
//  Created by Artem Denis on 09.05.2022.
//

import Foundation

struct DeviceList: Decodable {
    let devices: [DeviceListItem]
}

struct DeviceListItem: Decodable {
    let btCode: Int
    let title: String
    let description: String
    let fileName: String
    let programs: [Int]
}
