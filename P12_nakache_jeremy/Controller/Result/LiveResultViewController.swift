//
//  LiveResultViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit

class LiveResultViewController: UIViewController {
    
    var results = [ResponseFixture]()
    var league = [League]()
    
    @IBOutlet weak var resultTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTableView.dataSource = self
        resultTableView.delegate = self
        
    }
  
    
}
extension LiveResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SegueToDetailMatch", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "SegueToDetailMatch") {
            if let indexPath = self.resultTableView.indexPathForSelectedRow {
            let nextViewController = segue.destination as! MatchDetailViewController
                nextViewController.results = [results[indexPath.row]]
            }
        }
        
    }
}

extension LiveResultViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return league.count
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return league[section].name
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultMatchCell", for: indexPath) as? ResultTableViewCell
        else {
            return UITableViewCell()
        }
        let result = results[indexPath.row]
        let nameTeamHome = result.teams.home.name
        let nameTeamAway = result.teams.away.name
        let shortStatus = result.fixture.status.short
        let timeElapsed = result.fixture.status.elapsed
        let indicationTime = "\(shortStatus) \(timeElapsed ?? 0)'"
        var gameSchedule = ""
        
        var score = ""
        
        if shortStatus == "NS" || shortStatus == "PST" || shortStatus == "CANC" || shortStatus == "TBD"{
            score = "-"
        } else if shortStatus == "1H" || shortStatus == "2H" || shortStatus == "LIVE" {
            if let goalHome = result.goals.home , let goalAway = result.goals.away {
                score = "\(goalHome) - \(goalAway)" }
        } else if shortStatus == "HT" {
            if let halfTimeScoreHome = result.score.halftime.home, let halfTimeScoreAway = result.score.halftime.away {
                score = "\(halfTimeScoreHome) - \(halfTimeScoreAway)"
            }
        } else if shortStatus == "FT" {
            if let scoreFTHome = result.score.fulltime.home, let scoreFTAway = result.score.fulltime.away {
                score = "\(scoreFTHome) - \(scoreFTAway)"
            }
        }
        if shortStatus == "NS" {
            let dateStr = result.fixture.date
            let start = dateStr.index(dateStr.startIndex, offsetBy: 11)
            let end = dateStr.index(dateStr.endIndex, offsetBy: -9)
            let range = start..<end
            
            gameSchedule = "\(dateStr[range])H"
            
        } else {
            gameSchedule = ""
        }
        cell.configure(nameTeamHome: nameTeamHome, nameTeamAway: nameTeamAway, score: score, indication: indicationTime, gameSchedule: gameSchedule)
        return cell
    }
    
}


