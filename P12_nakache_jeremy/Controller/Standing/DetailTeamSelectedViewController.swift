//
//  DetailTeamSelectedViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit
import Alamofire

class DetailTeamSelectedViewController: UIViewController, UITabBarDelegate {
    
    var standing = [Standing]()
    var teamRepository = TeamsRepository()
    
    @IBOutlet weak var standingTeamSelectedLabel: UILabel!
    @IBOutlet weak var nameStadiumTeamSelected: UILabel!
    @IBOutlet weak var addressStadiumTeamSelected: UILabel!
    @IBOutlet weak var nameTeamSelected: UILabel!
    @IBOutlet weak var foundInDateTeamSelected: UILabel!
    @IBOutlet weak var imageStadiumTeamSelected: UIImageView!
    @IBOutlet weak var cityStadium: UILabel!
    @IBOutlet weak var logoTeamImageView: UIImageView!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var surfaceStadiumLabel: UILabel!
    @IBOutlet weak var viewStadiumDetail: UIView!
    @IBOutlet weak var containerView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getDataTeamSelected()
        imageStadiumTeamSelected.alpha = 0.6
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
      
    }
    private func configure() {
        if let urlLogo = standing.first?.team.logo {
            getImage(with: urlLogo, imageView: logoTeamImageView)
        }
        if let rank = standing.first?.rank {
            standingTeamSelectedLabel.text = "N°\(rank)"
        }
        
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
    
    private func getDataTeamSelected() {
        guard let selectedTeamId = standing.first?.team.id else {
            return }
        
        teamRepository.getDataTeams(endPoint: "teams?id=\(selectedTeamId)"){ [weak self] result in
            if let response = result.response.first {
                DispatchQueue.main.async {
                    self?.addressStadiumTeamSelected.text = response.venue.address
                    self?.nameTeamSelected.text = response.team.name
                    self?.nameStadiumTeamSelected.text = response.venue.name
                    self?.navigationItem.title = response.team.name
                    self?.capacityLabel.text = "\(response.venue.capacity) places"
                    self?.cityStadium.text = response.venue.city
                    self?.surfaceStadiumLabel.text = "surface \(response.venue.surface)"
                    if let founded = result.response.first?.team.founded {
                        self?.foundInDateTeamSelected.text = "Créé en \(founded)"
                    }
                    if let urlLogo = result.response.first?.venue.image {
                        self?.getImage(with: urlLogo, imageView: (self?.imageStadiumTeamSelected)!)
                    }
                }
            }
        }
    }
}
