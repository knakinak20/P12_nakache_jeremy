//
//  TeamsRepository.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import Foundation
import Alamofire

class TeamsRepository {
    
    private let manager: Session
    
    init(manager: Session = .default) {
        self.manager = manager
    }
    
    func getDataTeams(endPoint: String, completion: @escaping ((Result<TeamsStructJson, Error>) -> Void)) {
        
        let header : HTTPHeaders = ["x-rapidapi-key": "8205d1fbdf74d31764e3ad69e52a433b"]
        let url = "https://v3.football.api-sports.io/\(endPoint)"
        
        manager.request(url, method: .get, encoding: URLEncoding.queryString, headers: header).validate().responseDecodable(of: TeamsStructJson.self) { (response) in
            if let error = response.error {
                completion (.failure(error))
            } else if let standing = response.value {
                completion (.success(standing))
            }
        }
    }
}
