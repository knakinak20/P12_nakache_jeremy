//
//  StandingTableViewCell.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit
import Alamofire
import AlamofireImage

class StandingTableViewCell: UITableViewCell {

         
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameTeamLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var playedLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var drawLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var goalsDiffLabel: UILabel!
    
    
            override func awakeFromNib() {
                super.awakeFromNib()
                
                // Background
                self.backgroundColor = .clear

            }
    
    func configure(rank: String, nameTeam: String, point: String, played: String, win: String, draw: String, lose : String, goalsDiff: String, logoUrl: String ) {
        
        rankLabel.text = rank
        nameTeamLabel.text = nameTeam
        pointsLabel.text = point
        playedLabel.text = played
        winLabel.text = win
        drawLabel.text = draw
        loseLabel.text = lose
        goalsDiffLabel.text = goalsDiff
        getImage(with: logoUrl)
    }
    
    private func getImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            logoImageView.image = UIImage(named: "imageDefault")
            return
        }
    
    AF.request(url).responseImage { [weak self] response in
        if case .success(let image) = response.result {
            self?.logoImageView.image = image
        } else {
            self?.logoImageView.image = UIImage(named: "imageDefault")
        }
        
    }
    
    }

}


