//
//  LiveResultViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit

class LiveResultViewController: UIViewController {
    
    var results = [ResponseFixture]()
    @IBOutlet weak var resultTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTableView.dataSource = self
        resultTableView.delegate = self
        
    }
  
    
}
extension LiveResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SegueToDetailMatch", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "SegueToDetailMatch") {
            let nextViewController = segue.destination as! MatchDetailViewController
            nextViewController.results = results
            
        }
        
    }
}

extension LiveResultViewController: UITableViewDataSource {
    
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
           
        cell.configure(nameTeamHome: nameTeamHome, nameTeamAway: nameTeamAway, score: score, indication: indicationTime)
        return cell
    }
    
}


