//
//  ResultTableViewCell.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit

import Alamofire

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var teamHomeName: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var teamAwayName: UILabel!
    @IBOutlet weak var IndicationTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(nameTeamHome : String, nameTeamAway: String, score: String, indication : String) {
        
        teamHomeName.text = nameTeamHome
        teamAwayName.text = nameTeamAway
        scoreLabel.text = score
        IndicationTimeLabel.text = indication
    }
}
