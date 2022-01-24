//
//  ResultStructJson.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import Foundation

// MARK: - Welcome
struct FixtureResponse: Decodable {
    let get: String
    let parameters: FixtureParameters
    let errors: [String]
    let results: Int
    let paging: FixturePaging
    let response: [ResponseFixture]
}

// MARK: - Paging
struct FixturePaging : Decodable{
    let current, total: Int
}

// MARK: - Parameters
struct FixtureParameters: Decodable {
    let date: String
    let timezone: String
}


// MARK: - Response
struct ResponseFixture : Decodable{
    let fixture: Fixture
    let league: FixtureLeague
    let teams: Teams
    let goals: FixtureGoals
    let score: Score
}

// MARK: - Fixture
struct Fixture : Decodable{
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
struct Periods : Decodable{
    let first, second: Int?
}

// MARK: - Status
struct Status: Decodable {
    let long: String
    let short: String
    let elapsed: Int?
}

// MARK: - Venue
struct FixtureVenue : Decodable{
    let id: Int?
    let name, city: String?
}

// MARK: - Goals
struct FixtureGoals : Decodable{
    let home, away: Int?
}

// MARK: - League
struct FixtureLeague : Decodable{
    let id: Int
    let name, country: String
    let logo: String
    let flag: String?
    let season: Int
    let round: String
}

// MARK: - Score
struct Score : Decodable{
    let halftime, fulltime, extratime, penalty: FixtureGoals
}

// MARK: - Teams
struct Teams: Decodable {
    let home, away: Away
}

// MARK: - Away
struct Away: Decodable {
    let id: Int
    let name: String
    let logo: String
    let winner: Bool?
}

