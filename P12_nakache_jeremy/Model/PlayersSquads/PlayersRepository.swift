//
//  PlayersRepository.swift
//  P12_nakache_jeremy
//
//  Created by user on 25/01/2022.
//

import Foundation
import Alamofire

class PlayersRepository {

    private let manager: Session
    
    init(manager: Session = .default) {
        self.manager = manager
    }
    
func getPlayers(endPoint: String, completion: @escaping ((Result<PlayersSquads, Error>) -> Void)) {

    let header : HTTPHeaders = ["x-rapidapi-key": "8205d1fbdf74d31764e3ad69e52a433b"]
    let url = "https://v3.football.api-sports.io/\(endPoint)"
    
    manager.request(url, method: .get, encoding: URLEncoding.queryString, headers: header).validate().responseDecodable(of: PlayersSquads.self) { (response) in
        if let error = response.error {
            completion (.failure(error))
        } else if let player = response.value {
            completion (.success(player))
        }
    }
}
}
