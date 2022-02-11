//
//  EventsJsonStruct.swift
//  P12_nakache_jeremy
//
//  Created by user on 02/02/2022.
//

import Foundation

// MARK: - Welcome
struct EventsJsonStruct: Codable {
    let get: String
    let parameters: ParametersEvents
    let errors: [String]
    let results: Int
    let paging: PagingEvents
    let response: [ResponseEvents]
}

// MARK: - Paging
struct PagingEvents: Codable {
    let current, total: Int
}

// MARK: - Parameters
struct ParametersEvents: Codable {
    let fixture: String
}

// MARK: - Response
struct ResponseEvents: Codable {
    let time: Time
    let team: TeamEvent
    let player, assist: Assist
    let type, detail: String
    let comments: String?
}

// MARK: - Assist
struct Assist: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Team
struct TeamEvent: Codable {
    let id: Int
    let name: String
    let logo: String
}

// MARK: - Time
struct Time: Codable {
    let elapsed: Int?
    let extra: Int?
}
