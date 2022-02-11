//
//  PlayersStructJson.swift
//  P12_nakache_jeremy
//
//  Created by user on 25/01/2022.
//

import Foundation

// MARK: - PlayersSquads
struct PlayersSquads: Codable {
    let get: String
    let parameters: PlayersParameters
    let errors: [String]
    let results: Int
    let paging: PlayersPaging
    let response: [PlayersResponse]
}

// MARK: - Paging
struct PlayersPaging: Codable {
    let current, total: Int
}

// MARK: - Parameters
struct PlayersParameters: Codable {
    let team: String
}

// MARK: - Response
struct PlayersResponse: Codable {
    let team: PlayersTeam
    let players: [Player]
}

// MARK: - Player
struct Player: Codable {
    let id: Int
    let name: String
    let age: Int
    let number: Int?
    let position: String
    let photo: String
}


// MARK: - Team
struct PlayersTeam: Codable {
    let id: Int
    let name: String
    let logo: String
}
