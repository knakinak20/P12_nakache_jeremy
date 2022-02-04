//
//  EventsRepository.swift
//  P12_nakache_jeremy
//
//  Created by user on 02/02/2022.
//

import Foundation

class EventsRepository {

func getEvents(endPoint: String, completion: @escaping ((EventsJsonStruct) -> Void)) {
    let header1 = "8205d1fbdf74d31764e3ad69e52a433b"
    let header2 = "v3.football.api-sports.io"
    let url = "https://v3.football.api-sports.io/\(endPoint)"
    
    
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.addValue(header1, forHTTPHeaderField: "x-rapidapi-key")
    request.addValue(header2, forHTTPHeaderField: "x-rapidapi-host")
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let launch = try decoder.decode(EventsJsonStruct.self, from: data)
                completion(launch)
            } catch _ {
                print("alert")
                return

            }
        }

    }
    task.resume()
}
}
