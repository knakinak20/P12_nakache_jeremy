//
//  ResultTableViewCell.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit


class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var teamHomeName: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var teamAwayName: UILabel!
    @IBOutlet weak var IndicationTimeLabel: UILabel!
    @IBOutlet weak var gameSheduleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(nameTeamHome : String, nameTeamAway: String, score: String, indication : String, gameSchedule: String, status: String) {
        
        teamHomeName.text = nameTeamHome
        teamAwayName.text = nameTeamAway
        scoreLabel.text = score
        IndicationTimeLabel.text = indication
        gameSheduleLabel.text = gameSchedule
        statusLabel.text = status
    }
}
