//
//  PlayersStructJson.swift
//  P12_nakache_jeremy
//
//  Created by user on 25/01/2022.
//

import Foundation

// MARK: - PlayersSquads
struct PlayersSquads: Decodable {
    let get: String
    let parameters: PlayersParameters
    let errors: [String]
    let results: Int
    let paging: PlayersPaging
    let response: [PlayersResponse]
}

// MARK: - Paging
struct PlayersPaging: Decodable {
    let current, total: Int
}

// MARK: - Parameters
struct PlayersParameters: Decodable {
    let team: String
}

// MARK: - Response
struct PlayersResponse: Decodable {
    let team: PlayersTeam
    let players: [Player]
}

// MARK: - Player
struct Player: Decodable {
    let id: Int
    let name: String
    let age: Int
    let number: Int?
    let position: String
    let photo: String
}


// MARK: - Team
struct PlayersTeam: Decodable {
    let id: Int
    let name: String
    let logo: String
}
