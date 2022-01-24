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
        return 100
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
        if let scoreHome = result.score.fulltime.home, let scoreAway = result.score.fulltime.away {
            let nameTeamHome = result.teams.home.name
            let nameTeamAway = result.teams.away.name
            let urlLogoTeamHome = result.teams.home.logo
            let urlLogoTeamAway = result.teams.away.logo
            let score = "\(scoreHome) - \(scoreAway)"
        cell.configure(urlLogoTeamHome: urlLogoTeamHome, urlLogoTeamAway: urlLogoTeamAway, nameTeamHome: nameTeamHome, nameTeamAway: nameTeamAway, score: score)
            
        }
        return cell
    }
    
}


