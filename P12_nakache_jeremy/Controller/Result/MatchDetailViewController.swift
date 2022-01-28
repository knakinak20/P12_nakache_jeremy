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
    
    var results = [ResponseFixture]()
    var score = ""
    
    @IBOutlet weak var nameTeamHomeLabel: UILabel!
    @IBOutlet weak var nameTeamAwayLabel: UILabel!
    @IBOutlet weak var logoTeamHome: UIImageView!
    @IBOutlet weak var logoTeamAway: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    func configure(){
        
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
        getScore()
    }
    
    func getImage(with urlString: String, imageView: UIImageView) {
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
    
    func getScore() {
        
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
    
    
    
}
