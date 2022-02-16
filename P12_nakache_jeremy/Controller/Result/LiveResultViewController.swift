//
//  LiveResultViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit

class LiveResultViewController: UIViewController {
    
    
    var results = [ResponseFixture]() {
        didSet {
            fixtureMap = [FixtureLeague: [ResponseFixture]]()
            
            for fixture in results {
                let league = fixture.league
                if fixtureMap[league] == nil {
                    fixtureMap[league] = [ResponseFixture]()
                }
                fixtureMap[league]?.append(fixture)
                
            }
            
            fixtureMap = fixtureMap.filter { $0.key.id == 39 || $0.key.id == 66 || $0.key.id == 140 || $0.key.id == 269 || $0.key.id == 142 || $0.key.id == 40 || $0.key.id == 43 || $0.key.id == 699 || $0.key.id == 135 || $0.key.id == 136 || $0.key.id == 138 || $0.key.id == 139 || $0.key.id == 128 || $0.key.id == 134 || $0.key.id == 132 || $0.key.id == 129 || $0.key.id == 61 || $0.key.id == 62 || $0.key.id == 63 || $0.key.id == 64 || $0.key.id == 78 || $0.key.id == 79 || $0.key.id == 80 || $0.key.id == 82 || $0.key.id == 88 || $0.key.id == 91 || $0.key.id == 94 || $0.key.id == 95 }
            
            orderedLeagueNames = fixtureMap.keys.sorted()
        }
    }
    
    
    private var fixtureMap = [FixtureLeague: [ResponseFixture]]()
    private var orderedLeagueNames = [FixtureLeague]()
    
    @IBOutlet weak var resultTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTableView.dataSource = self
        resultTableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resultTableView.reloadData()
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
                let indexpathsSection = indexPath.section
                let index = fixtureMap.index(fixtureMap.startIndex, offsetBy: indexpathsSection)
                let league = fixtureMap[index]
                
                nextViewController.results = [league.value[indexPath.row]]
                
            }
        }
        
    }
}

extension LiveResultViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderedLeagueNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < orderedLeagueNames.count else {
            return 0
        }
        let index = orderedLeagueNames[section]
        let league = fixtureMap[index]
        
        return league?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < orderedLeagueNames.count else {
            return "N/A"
        }
        
        let league = orderedLeagueNames[section]
        
        return league.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultMatchCell", for: indexPath) as? ResultTableViewCell
        else {
            return UITableViewCell()
        }
        
        guard indexPath.section < fixtureMap.keys.count else {
            return UITableViewCell()
        }
        
        
        let index = orderedLeagueNames[indexPath.section]
        
        
        guard let fixtures = fixtureMap[index], indexPath.row < fixtures.count else {
            return UITableViewCell()
        }
        
        let fixture = fixtures[indexPath.row]
        
        let nameTeamHome = fixture.teams.home.name
        let nameTeamAway = fixture.teams.away.name
        let shortStatus = fixture.fixture.status.short
        let timeElapsed = fixture.fixture.status.elapsed
        let indicationTime = "\(timeElapsed ?? 0)'"
        let status = fixture.fixture.status.long
        var gameSchedule = ""
        
        var score = ""
        
        if shortStatus == "NS" || shortStatus == "PST" || shortStatus == "CANC" || shortStatus == "TBD"{
            score = "-"
        } else if shortStatus == "1H" || shortStatus == "2H" || shortStatus == "LIVE" {
            if let goalHome = fixture.goals.home , let goalAway = fixture.goals.away {
                score = "\(goalHome) - \(goalAway)" }
        } else if shortStatus == "HT" {
            if let halfTimeScoreHome = fixture.score.halftime.home, let halfTimeScoreAway = fixture.score.halftime.away {
                score = "\(halfTimeScoreHome) - \(halfTimeScoreAway)"
            }
        } else if shortStatus == "FT" {
            if let scoreFTHome = fixture.score.fulltime.home, let scoreFTAway = fixture.score.fulltime.away {
                score = "\(scoreFTHome) - \(scoreFTAway)"
            }
        }
        if shortStatus == "NS" {
            let dateStr = fixture.fixture.date
            let start = dateStr.index(dateStr.startIndex, offsetBy: 11)
            let end = dateStr.index(dateStr.endIndex, offsetBy: -9)
            let range = start..<end
            
            gameSchedule = "\(dateStr[range])H"
            
        } else {
            gameSchedule = ""
        }
        
        cell.configure(nameTeamHome: nameTeamHome, nameTeamAway: nameTeamAway, score: score, indication: indicationTime, gameSchedule: gameSchedule, status: status)
        return cell
    }
    
}


