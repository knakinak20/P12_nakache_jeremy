//
//  TeamCompositionViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 25/01/2022.
//

import UIKit

class TeamCompositionViewController: UIViewController {

     var playersRepository = PlayersRepository()
    var playersSquad = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func getDataPlayers(){
        playersRepository.getPlayers(endPoint: "marseille") { result in
            DispatchQueue.main.async {
            if let players = result.response.first?.players {
                self.playersSquad = players
           
            }
            }
        }
    }

}
