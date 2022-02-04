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
            fixtureMap = [String: [ResponseFixture]]()
            var sectionSet = Set<String>()
            for fixture in results {
                let name = fixture.league.name
                if fixtureMap[name] == nil {
                    fixtureMap[name] = [ResponseFixture]()
                }
                fixtureMap[name]?.append(fixture)
                sectionSet.insert(name)
            }
            sections = Array(sectionSet)
        }
    }
    
    private var fixtureMap = [String: [ResponseFixture]]()
    private var sections = [String]()
    
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
                let nameResultindexpathsSection = sections[indexpathsSection]
                if let array = fixtureMap[nameResultindexpathsSection] {
                nextViewController.results = [array[indexPath.row]]
                }
            }
        }
        
    }
}

extension LiveResultViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        let leagueName = sections[section]
        
        return fixtureMap[leagueName]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sections.count else {
            return "N/A"
        }
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultMatchCell", for: indexPath) as? ResultTableViewCell
        else {
            return UITableViewCell()
        }
        
        guard indexPath.section < sections.count else {
            return UITableViewCell()
        }
        
        let leagueName = sections[indexPath.section]
        
        guard let fixtures = fixtureMap[leagueName] else {
            return UITableViewCell()
        }
        
        guard indexPath.row < fixtures.count else {
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


