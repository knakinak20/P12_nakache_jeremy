//
//  DetailTeamSelectedViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit
import Alamofire
import AlamofireImage

let myNotificationKey = "team.notificationKey"

class DetailTeamSelectedViewController: UIViewController {
    
    
    var standing = [Standing]()
    var teamRepository = TeamsRepository()
    
    private let infoViewSegmentControlIndex = 0
    private let teamViewSegmentControlIndex = 1
    
    @IBOutlet weak var standingTeamSelectedLabel: UILabel!
    
    @IBOutlet weak var nameTeamSelected: UILabel!
    @IBOutlet weak var foundInDateTeamSelected: UILabel!
    @IBOutlet weak var logoTeamImageView: UIImageView!
    
    @IBOutlet weak var viewToSwitch: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    lazy var teamCompositionViewController: TeamCompositionViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var teamCompoviewController = storyboard.instantiateViewController(withIdentifier: "TeamCompositionViewController") as! TeamCompositionViewController
        //self.addViewControllerAsChildViewController(childViewController: teamCompoviewController)
        return teamCompoviewController
    }()
    
    lazy var infosStadiumViewController: InfosStadiumViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var infoStadiumviewController = storyboard.instantiateViewController(withIdentifier: "InfosStadiumViewController") as! InfosStadiumViewController
        ///self.addViewControllerAsChildViewController(childViewController: infoStadiumviewController)
        return infoStadiumviewController
    }()
    
    @IBAction func segmentControlTap(_ sender: UISegmentedControl) {
        let currentIndex = sender.selectedSegmentIndex
        if currentIndex == infoViewSegmentControlIndex {
            launchInfo()
        } else if currentIndex == teamViewSegmentControlIndex {
            launchTeam()
        } else {
            print("Invalid segment index")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure()
        
        getDataTeamSelected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        launchInfo()
    }
    
    private func setupView() {
        setupSegmentedControl()
        updateView()
    }
    
    func updateView() {
        infosStadiumViewController.view.isHidden = !(segmentedControl.selectedSegmentIndex == 0)
        teamCompositionViewController.view.isHidden = (segmentedControl.selectedSegmentIndex == 0)
//        if let idTeam = standing.first?.team.id {
//            NotificationCenter.default.post(name: Notification.Name(rawValue: myNotificationKey), object: self,userInfo: ["idTeam" : "\(idTeam)", "standing": standing])
//
//        }
    }
    private func setupSegmentedControl(){
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Infos", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Effectif Equipe", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc func selectionDidChange(sender: UISegmentedControl){
        updateView()
    }
    
    private func addViewControllerAsChildViewController(childViewController: UIViewController){
        addChild(childViewController)
        
        viewToSwitch.addSubview(childViewController.view)
        
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childViewController.didMove(toParent: self)
    }
    
    private func removeViewController(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
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
                    self?.nameTeamSelected.text = response.team.name
                    
                    if let founded = result.response.first?.team.founded {
                        self?.foundInDateTeamSelected.text = "Créé en \(founded)"
                    }
                }
            }
        }
    }
    
    private func launchInfo() {
        removeViewController(childViewController: teamCompositionViewController)
        infosStadiumViewController.standing = standing
        addViewControllerAsChildViewController(childViewController: infosStadiumViewController)
    }
    
    private func launchTeam() {
        removeViewController(childViewController: infosStadiumViewController)
        teamCompositionViewController.idTeam = standing.first?.team.id
        addViewControllerAsChildViewController(childViewController: teamCompositionViewController)
    }
}
