//
//  DetailTeamSelectedViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit
import Alamofire
import AlamofireImage


class DetailTeamSelectedViewController: UIViewController {
    
    
    var standing = [Standing]()
    private var teamRepository = TeamsRepository()
    
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
        return teamCompoviewController
    }()
    
    lazy var infosStadiumViewController: InfosStadiumViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var infoStadiumviewController = storyboard.instantiateViewController(withIdentifier: "InfosStadiumViewController") as! InfosStadiumViewController
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
    
    private func updateView() {
        infosStadiumViewController.view.isHidden = !(segmentedControl.selectedSegmentIndex == 0)
        teamCompositionViewController.view.isHidden = (segmentedControl.selectedSegmentIndex == 0)
        
    }
    private func setupSegmentedControl(){
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Infos", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Effectif Equipe", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc func selectionDidChange(sender: UISegmentedControl){ // selectedsegment change we uptade the view
        updateView()
    }
    
    private func addViewControllerAsChildViewController(childViewController: UIViewController){ // we add child view controller
        addChild(childViewController)
        
        viewToSwitch.addSubview(childViewController.view)
        
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childViewController.didMove(toParent: self)
    }
    
    private func removeViewController(childViewController: UIViewController) { // remove when we change view
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
    private func configure() { // configure team information
        if let urlLogo = standing.first?.team.logo {
            getImage(with: urlLogo, imageView: logoTeamImageView)
        }
        if let rank = standing.first?.rank {
            standingTeamSelectedLabel.text = "N°\(rank)"
        }
        
    }
    private func getImage(with urlString: String, imageView: UIImageView) { // setup logo teams
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
    
    private func getDataTeamSelected() { // call api to have team information
        guard let selectedTeamId = standing.first?.team.id else {
            return }
        
        teamRepository.getDataTeams(endPoint: "teams?id=\(selectedTeamId)"){ [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let team) :
                    if let response = team.response.first {
                        self?.nameTeamSelected.text = response.team.name
                        
                        if let founded = team.response.first?.team.founded {
                            self?.foundInDateTeamSelected.text = "Créé en \(founded)"
                        }
                    }
                case .failure(_):
                    self?.alert()
                    break
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
    
    private func alert() {
        let  confirmationAlert = UIAlertController(title: "No internet connection detected" , message: "Please check your internet connection and try again", preferredStyle: .actionSheet)
        confirmationAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action : UIAlertAction!) in }))
        
        present(confirmationAlert,animated: true, completion: nil)
    }
}
