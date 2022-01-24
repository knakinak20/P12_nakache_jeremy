//
//  StandingsStructJson.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import Foundation

struct StandingsStructJson: Decodable {
    let get: String
    let parameters: Parameters
    let errors: [String]
    let results: Int
    let paging: Paging
    let response: [Response]
}

// MARK: - Paging
struct Paging : Decodable {
    let current, total: Int
}

// MARK: - Parameters
struct Parameters: Decodable {
    let league, season: String
}

struct Response : Decodable{
    let league : League
}

struct League: Decodable {
    let id: Int?
    let name, country: String?
    let logo: String?
    let flag: String?
    let season: Int?
    let standings: [[Standing]]?
}

// MARK: - Standing
struct Standing: Decodable {
    let rank: Int
    let team: TeamStanding
    let points, goalsDiff: Int
    let group, form, status, description: String?
    let all, home, away: All
    let update: String
}

// MARK: - All
struct All: Decodable {
    let played, win, draw, lose: Int
    let goals: Goals
}

// MARK: - Goals
struct Goals: Decodable {
    let _for: Int?
    let against: Int?
}

// MARK: - Team
 struct TeamStanding: Decodable {
    let id: Int?
    let name: String?
    let logo: String
}
