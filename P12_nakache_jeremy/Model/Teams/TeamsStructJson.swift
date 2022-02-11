//
//  TeamsStructJson.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import Foundation

struct TeamsStructJson : Codable{
    let get: String?
    let parameters: ParametersTeam
    let errors: [String]
    let results: Int
    let paging: PagingTeam
    let response: [ResponseTeam]
}

// MARK: - Paging
struct PagingTeam : Codable {
    let current, total: Int
}

// MARK: - Parameters
struct ParametersTeam : Codable{
    let id: String
}


// MARK: - Response
struct ResponseTeam : Codable{
    let team : Team
    let venue: Venue
}

// MARK: - Team
struct Team : Codable {
    let id: Int
    let name: String
    let founded: Int?
    let national: Bool
    let logo: String
}

struct Venue: Codable {
    let id: Int
    let name : String
    let address: String
    let city: String
    let capacity: Int
    let surface : String
    let image: String
}
