//
//  TeamCompositionViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 25/01/2022.
//

import UIKit

class TeamCompositionViewController: UIViewController {


    @IBOutlet weak var compositionTeam: UITableView!
    
    var playersRepository = PlayersRepository()
    
    var playersSquad = [Player]() {
        didSet {
            compositionTeam.reloadData()
        }
    }
    
    
    var idTeam: Int? {
        didSet {
            getDataPlayers()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        compositionTeam.dataSource = self
        
    }
    
    func getDataPlayers(){
        guard let idTeam = idTeam else { return }
        
        playersRepository.getPlayers(endPoint: "players/squads?team=\(idTeam)") { result in
            guard let players = result.response.first?.players else { return }
            DispatchQueue.main.async {
                self.playersSquad = players
            }
        }
    }

}
extension TeamCompositionViewController: UITableViewDataSource {

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return playersSquad.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath)
            cell.textLabel?.text = playersSquad[indexPath.row].name
            return cell
        }

    }
