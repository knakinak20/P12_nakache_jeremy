//
//  StandingViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit

class StandingViewController: UIViewController {
    
    @IBOutlet weak var standingL1TableView: UITableView!
    
    
    private var repositoryStanding = StandingsRepository()
    private var teamRepository = TeamsRepository()
    var standings = [Standing]()
    //var team = [Team]()
    var selectedLigue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Classement \(selectedLigue) 2021/2022"
        
        self.standingL1TableView.delegate = self
        self.standingL1TableView.dataSource = self
        
        standingL1TableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        standingL1TableView.reloadData()
    }
}

extension StandingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SegueToDetail" {
            if let indexPath = self.standingL1TableView.indexPathForSelectedRow {
                let nextViewController = segue.destination as! DetailTeamSelectedViewController
                nextViewController.standing = [standings[indexPath.row]]
            }
        }
    }
    
}

extension StandingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandingTableViewCell", for: indexPath) as? StandingTableViewCell
        else {
            return UITableViewCell()
        }
        let standingRow = standings[indexPath.row]
        let rank = String(standingRow.rank)
        let points = String(standingRow.points)
        let played = String(standingRow.all.played)
        let win = String(standingRow.all.win)
        let draw = String(standingRow.all.draw)
        let lose = String(standingRow.all.lose)
        let goalsDiff = String(standingRow.goalsDiff)
        let logoUrl = standingRow.team.logo
        
        if  let nameTeam = standingRow.team.name {
            cell.configure(rank: rank, nameTeam: nameTeam, point: points, played: played, win: win, draw: draw, lose: lose, goalsDiff: goalsDiff,logoUrl: logoUrl)
            
        }
        return cell
    }
    
}


