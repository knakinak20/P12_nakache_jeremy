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
    var playerSection = [Any]()
    
    
    var idTeam: Int? {
        didSet {
            getDataPlayers()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        compositionTeam.dataSource = self
        compositionTeam.delegate = self
    }
    
    func getDataPlayers(){
        guard let idTeam = idTeam else { return }
        
        playersRepository.getPlayers(endPoint: "players/squads?team=\(idTeam)") { result in
            guard let players = result.response.first?.players else { return }
            DispatchQueue.main.async {
                self.playersSquad = players
//                for player in self.playersSquad {
//                    let section = "\(player.position) : \(player.name)"
//                    self.playerSection.append(section)
//
//                }
//                let stringSection = "\(self.playerSection)"
//                print (stringSection)
            }
        }
    }

}

extension TeamCompositionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerSquadTableViewCell", for: indexPath) as? PlayerSquadTableViewCell
            else {
                return UITableViewCell()
            }
            let playerSquad = playersSquad[indexPath.row]
            let name = playerSquad.name
            let image = playerSquad.photo
            let age = playerSquad.age
            let ageString = String(age)
            let position = playerSquad.position
            if let numberInt = playerSquad.number {
                let numberString = String(numberInt)
            
            
            cell.configure(name: name, image: image, age: ageString, position: position, number: numberString )
           
        }
            return cell
        }
        }
