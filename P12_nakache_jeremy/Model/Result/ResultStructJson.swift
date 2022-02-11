//
//  ResultStructJson.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import Foundation

// MARK: - Welcome
struct FixtureResponse: Codable {
    let get: String
    let parameters: FixtureParameters
    let errors: [String]
    let results: Int
    let paging: FixturePaging
    let response: [ResponseFixture]
}

// MARK: - Paging
struct FixturePaging : Codable{
    let current, total: Int
}

// MARK: - Parameters
struct FixtureParameters: Codable {
    let date: String
    let timezone: String
}


// MARK: - Response
struct ResponseFixture : Codable{
    let fixture: Fixture
    let league: FixtureLeague
    let teams: Teams
    let goals: FixtureGoals
    let score: Score
}

// MARK: - Fixture
struct Fixture : Codable{
    let id: Int
    let referee: String?
    let timezone: String
    let date: String
    let timestamp: Int
    let periods: Periods
    let venue: FixtureVenue
    let status: Status
}

// MARK: - Periods
struct Periods : Codable{
    let first, second: Int?
}

// MARK: - Status
struct Status: Codable {
    let long: String
    let short: String
    let elapsed: Int?
}

// MARK: - Venue
struct FixtureVenue : Codable{
    let id: Int?
    let name, city: String?
}

// MARK: - Goals
struct FixtureGoals : Codable{
    let home, away: Int?
}

// MARK: - League
struct FixtureLeague : Codable, Hashable, Comparable {
    static func < (lhs: FixtureLeague, rhs: FixtureLeague) -> Bool {
        return lhs.name < rhs.name 
    }
    
    let id: Int
    let name, country: String
    let logo: String
    let flag: String?
    let season: Int
    let round: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FixtureLeague, rhs: FixtureLeague) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Score
struct Score : Codable{
    let halftime, fulltime, extratime, penalty: FixtureGoals
}

// MARK: - Teams
struct Teams: Codable {
    let home, away: Away
}

// MARK: - Away
struct Away: Codable {
    let id: Int
    let name: String
    let logo: String
    let winner: Bool?
}

