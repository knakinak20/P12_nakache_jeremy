//
//  StandingsStructJson.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import Foundation

struct StandingsStructJson: Codable {
    let get: String
    let parameters: Parameters
    let errors: [String]
    let results: Int
    let paging: Paging
    let response: [Response]
}

// MARK: - Paging
struct Paging : Codable {
    let current, total: Int
}

// MARK: - Parameters
struct Parameters: Codable {
    let league, season: String
}

struct Response : Codable{
    let league : League
}

struct League: Codable {
    
    let id: Int?
    let name, country: String?
    let logo: String?
    let flag: String?
    let season: Int?
    let standings: [[Standing]]?
}

// MARK: - Standing
struct Standing: Codable {
    let rank: Int
    let team: TeamStanding
    let points, goalsDiff: Int
    let group, form, status, description: String?
    let all, home, away: All
    let update: String
}

// MARK: - All
struct All: Codable {
    let played, win, draw, lose: Int
    let goals: Goals
}

// MARK: - Goals
struct Goals: Codable {
    let _for: Int?
    let against: Int?
}

// MARK: - Team
 struct TeamStanding: Codable {
    let id: Int?
    let name: String?
    let logo: String
}
