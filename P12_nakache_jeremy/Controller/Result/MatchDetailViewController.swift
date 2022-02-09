//
//  MatchDetailViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit
import Alamofire
import AlamofireImage

class MatchDetailViewController: UIViewController {
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    private var eventsRepository = EventsRepository()
    var results = [ResponseFixture]()
    private var events = [ResponseEvents]()
    private var score = ""
    
    @IBOutlet weak var nameTeamHomeLabel: UILabel!
    @IBOutlet weak var nameTeamAwayLabel: UILabel!
    @IBOutlet weak var logoTeamHome: UIImageView!
    @IBOutlet weak var logoTeamAway: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scheduleGameLabel: UILabel!
    @IBOutlet weak var statusGameLabel: UILabel!
    @IBOutlet weak var elapsedTimeGameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        
        configure()
        getEvent()
        
    }
    private func configure(){
        
        if let nameTeamHome = results.first?.teams.home.name {
            nameTeamHomeLabel.text = nameTeamHome
        }
        if let nameTeamAway = results.first?.teams.away.name {
            nameTeamAwayLabel.text = nameTeamAway
        }
        if let urlLogoTeamHome = results.first?.teams.home.logo {
            getImage(with: urlLogoTeamHome, imageView: logoTeamHome)
        }
        if let urlLogoTeamAway = results.first?.teams.away.logo {
            getImage(with: urlLogoTeamAway, imageView: logoTeamAway)
        }
        if let status = results.first?.fixture.status.long {
            statusGameLabel.text = status
        }
        if let schedule = results.first?.fixture {
            let dateStr = schedule.date
            let start = dateStr.index(dateStr.startIndex, offsetBy: 11)
            let end = dateStr.index(dateStr.endIndex, offsetBy: -9)
            let range = start..<end
            
            let referee = schedule.referee
            let nameVenue = schedule.venue.name
            scheduleGameLabel.text = "\(dateStr[range])h, \(nameVenue ?? ""), \(referee ?? "")"
        }
        if let elapsedTime = results.first?.fixture.status.elapsed {
            elapsedTimeGameLabel.text = "\(elapsedTime)'"
        } else {
            elapsedTimeGameLabel.text = "0'"
        }
        getScore()
    }
    
    private func getImage(with urlString: String, imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            imageView.image = UIImage(named: "imageDefault")
            return
        }
        
        AF.request(url).responseImage {  response in
            if case .success(let image) = response.result {
                imageView.image = image
            } else {
                imageView.image = UIImage(named: "imageDefault")
            }
            
        }
        
    }
    
    private func getScore() {
        
        let shortStatus = results.first?.fixture.status.short
        
        if shortStatus == "NS" || shortStatus == "PST" || shortStatus == "CANC" || shortStatus == "TBD"{
            score = "-"
        } else if shortStatus == "1H" || shortStatus == "2H" || shortStatus == "LIVE" {
            if let goalHome = results.first?.goals.home , let goalAway = results.first?.goals.away {
                score = "\(goalHome) - \(goalAway)" }
        } else if shortStatus == "HT" {
            if let halfTimeScoreHome = results.first?.score.halftime.home, let halfTimeScoreAway = results.first?.score.halftime.away {
                score = "\(halfTimeScoreHome) - \(halfTimeScoreAway)"
            }
        } else if shortStatus == "FT" {
            if let scoreFTHome = results.first?.score.fulltime.home, let scoreFTAway = results.first?.score.fulltime.away {
                score = "\(scoreFTHome) - \(scoreFTAway)"
            }
        }
        scoreLabel.text = score
    }
    
    private func getEvent() {
        
        guard let idFixture = results.first?.fixture.id else {
            return }
        
        eventsRepository.getEvents(endPoint: "fixtures/events?fixture=\(idFixture)") { result in
            DispatchQueue.main.async {
                self.events = result.response
                self.eventsTableView.reloadData()
            }
        }
    }
    
}

extension MatchDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MatchDetailViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath)
        
        let event = events[indexPath.row]
        let typeEvent = event.type
        let playerEvent = event.player.name
        let typeDetailEvent = event.detail
        let timeEvent = event.time.elapsed
        
        let teamHome = results.first?.teams.home.name
        let teamEvent = event.team.name
        
        if teamEvent == teamHome {
            cell.textLabel?.textAlignment = .left
        } else {
            cell.textLabel?.textAlignment = .right
        }
        
        cell.textLabel?.text = "\(timeEvent ?? 0)' \(playerEvent ?? "") :\n\(typeEvent), \(typeDetailEvent)"
        return cell
    }
    
}
