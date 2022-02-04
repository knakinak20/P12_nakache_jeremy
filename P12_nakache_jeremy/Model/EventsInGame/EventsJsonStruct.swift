//
//  EventsJsonStruct.swift
//  P12_nakache_jeremy
//
//  Created by user on 02/02/2022.
//

import Foundation

// MARK: - Welcome
struct EventsJsonStruct: Decodable {
    let get: String
    let parameters: ParametersEvents
    let errors: [String]
    let results: Int
    let paging: PagingEvents
    let response: [ResponseEvents]
}

// MARK: - Paging
struct PagingEvents: Decodable {
    let current, total: Int
}

// MARK: - Parameters
struct ParametersEvents: Decodable {
    let fixture: String
}

// MARK: - Response
struct ResponseEvents: Decodable {
    let time: Time
    let team: TeamEvent
    let player, assist: Assist
    let type, detail: String
    let comments: String?
}

// MARK: - Assist
struct Assist: Decodable {
    let id: Int?
    let name: String?
}

// MARK: - Team
struct TeamEvent: Decodable {
    let id: Int
    let name: String
    let logo: String
}

// MARK: - Time
struct Time: Decodable {
    let elapsed: Int?
    let extra: Int?
}
