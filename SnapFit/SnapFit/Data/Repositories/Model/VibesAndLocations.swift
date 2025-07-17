//
//  Vibes.swift
//  SnapFit
//
//  Created by 정정욱 on 8/11/24.
//

import Foundation

// MARK: - WelcomeElement
struct Vibe: Codable {
    let id: Int?
    let name: String?
}

typealias Vibes = [Vibe]


struct MakerLocation: Codable {
    let id: Int?
    let adminName: String?
}

typealias MakerLocations = [MakerLocation]
