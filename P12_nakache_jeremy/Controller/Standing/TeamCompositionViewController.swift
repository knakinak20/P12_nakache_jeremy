//
//  TeamCompositionViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 25/01/2022.
//

import UIKit



class TeamCompositionViewController: UIViewController {
    
    @IBOutlet weak var compositionTeam: UITableView!
    
    private var playersRepository = PlayersRepository()
    
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
        compositionTeam.delegate = self
    }
    
    private func getDataPlayers(){ // call api to have player's information
        guard let idTeam = idTeam else { return }
        
        playersRepository.getPlayers(endPoint: "players/squads?team=\(idTeam)") { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let player) :
                    guard let players = player.response.first?.players else { return }
                    self.playersSquad = players
                    
                case .failure(_):
                    self.alert()
                    break
                }
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
            cell.configure(name: name, image: image, age: ageString, position: position, number:  numberString)
        } else {
            cell.configure(name: name, image: image, age: ageString, position: position, number: "N/A")
        }
        return cell
    }
    private func alert() {
        let  confirmationAlert = UIAlertController(title: "No internet connection detected" , message: "Please check your internet connection and try again", preferredStyle: .actionSheet)
        confirmationAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action : UIAlertAction!) in }))
        
        present(confirmationAlert,animated: true, completion: nil)
    }
}
