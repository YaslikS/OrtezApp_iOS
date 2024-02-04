//
//  ProgramList.swift
//  OrtezApp
//
//  Created by Artem Denis on 09.05.2022.
//

import Foundation

struct ProgramList: Codable {
    let programs: [ProgramListItem]
}

struct ProgramListItem: Equatable, Codable {
    
    let id: Int
    var statsTitle: String? = nil
    let title: String
    let description: String
    let file: String
    let icon: String
    let electrode: Int
    let stage: [StageListItem]
    
    static func == (lhs: ProgramListItem, rhs: ProgramListItem) -> Bool {
        lhs.id          == rhs.id          &&
        lhs.title       == rhs.title       &&
        lhs.description == rhs.description &&
        lhs.electrode   == rhs.electrode
    }
    
}

struct StageListItem: Codable {
    let num: Int
    var generation: Bool?
    let duration: Int
    let startPower: Int
    let power: Int
    let frequency: Int
    let am: Bool
    let amMode: Int
    let intensivity: Int
    let fm: Bool
    let comment: String
}
