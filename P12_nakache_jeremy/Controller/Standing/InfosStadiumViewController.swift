//
//  InfosStadiumViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 27/01/2022.
//

import UIKit
import Alamofire
import AlamofireImage

class InfosStadiumViewController: UIViewController {
    
    var standing = [Standing]() {
        didSet {
            update()
        }
    }
    private var teamRepository = TeamsRepository()
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var nameStadium: UILabel!
    @IBOutlet weak var addressStadium: UILabel!
    @IBOutlet weak var capacityStadium: UILabel!
    @IBOutlet weak var surfaceStadium: UILabel!
    @IBOutlet weak var imageStadium: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageStadium.alpha = 0.6
    }
    
    
    private func update() { // call api to have selected team information
        guard let id = standing.first?.team.id else { return }
        
        teamRepository.getDataTeams(endPoint: "teams?id=\(id)") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let team) :
                    guard  let responseTeam = team.response.first else { return }
                    self.updateView(with: responseTeam)
                case .failure(_):
                    self.alert()
                    break
                }
            }
        }
    }
    
    private func updateView(with responseTeam: ResponseTeam) { // setup the view of  stadium's information
        self.cityLabel.text = responseTeam.venue.city
        self.addressStadium.text = responseTeam.venue.address
        self.nameStadium.text = responseTeam.venue.name
        self.navigationItem.title = responseTeam.team.name
        self.capacityStadium.text = "\(responseTeam.venue.capacity) places"
        self.surfaceStadium.text = "surface \(responseTeam.venue.surface)"
        let urlLogo = responseTeam.venue.image
        getImage(with: urlLogo, imageView: self.imageStadium)
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
    private func alert() {
        let  confirmationAlert = UIAlertController(title: "No internet connection detected" , message: "Please check your internet connection and try again", preferredStyle: .actionSheet)
        confirmationAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action : UIAlertAction!) in }))
        
        present(confirmationAlert,animated: true, completion: nil)
    }
}
