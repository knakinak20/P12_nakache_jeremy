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
    @IBOutlet weak var teamHomeLogo: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var teamAwayName: UILabel!
    @IBOutlet weak var teamAwayLogo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(urlLogoTeamHome: String, urlLogoTeamAway: String, nameTeamHome : String, nameTeamAway: String, score: String){
        
        teamHomeName.text = nameTeamHome
        teamAwayName.text = nameTeamAway
        scoreLabel.text = score
        getImage(with: urlLogoTeamHome, imageView: teamHomeLogo)
        getImage(with: urlLogoTeamAway, imageView: teamAwayLogo)
    }
    private func getImage(with urlString: String, imageView : UIImageView) {
        guard let url = URL(string: urlString) else {
            imageView.image = UIImage(named: "imageDefault")
            return
        }
    
    AF.request(url).responseImage { [weak self] response in
        if case .success(let image) = response.result {
            self?.imageView?.image = image
        } else {
            self?.imageView?.image = UIImage(named: "imageDefault")
        }
        
    }
    
    }
    
}
