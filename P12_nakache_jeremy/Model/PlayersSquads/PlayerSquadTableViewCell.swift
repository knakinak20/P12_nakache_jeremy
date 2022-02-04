//
//  PlayerSquadTableViewCell.swift
//  P12_nakache_jeremy
//
//  Created by user on 31/01/2022.
//

import UIKit
import Alamofire
import AlamofireImage


class PlayerSquadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerAge: UILabel!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var playerNumber: UILabel!
    
    
    func configure(name : String, image : String, age: String, position: String, number: String) {
        
        playerName.text = name
        playerAge.text = "\(age) ans"
        playerPosition.text = position
        playerNumber.text = "Numéro \(number)"
        
        getImage(with: image)
    }
    
    private func getImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            playerImage.image = UIImage(named: "imageDefault")
            return
        }
    
    AF.request(url).responseImage { [weak self] response in
        if case .success(let image) = response.result {
            self?.playerImage.image = image
        } else {
            self?.playerImage.image = UIImage(named: "imageDefault")
        }
        
    }
    
    }
    
    
}
