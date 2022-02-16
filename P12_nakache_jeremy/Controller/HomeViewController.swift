//
//  HomeViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let resultRepository = ResultRepository()
    private var results = [ResponseFixture]()
    private var dateToday = ""
    @IBOutlet weak var resultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultButton.isUserInteractionEnabled = true
        resultButton.layer.opacity = 1
    }
    
    @IBAction func getResult(_ sender: Any) {
        resultButton.isUserInteractionEnabled = false
        getResultData()
        
    }
    private func getCurrentShortDate() { // this function gives us the current date in the desired format
        let todaysDate = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateToday = dateFormatter.string(from: todaysDate as Date)
    }
    
    private func getResultData() { // we call api and take the result match of the day
        getCurrentShortDate()
        
        resultRepository.getResults(endPoint: "fixtures?date=\(dateToday)&timezone=Europe/Paris") { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let matchResult) :
                    self?.results = matchResult.response
                    self?.performSegue(withIdentifier: "SegueToResultDay", sender: self)
                    
                case .failure(_):
                    self?.alert()
                    break
                }
                self?.resultButton.layer.opacity = 1
                self?.resultButton.isUserInteractionEnabled = true
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToResultDay" {
            if let nextViewController = segue.destination as? LiveResultViewController {
                nextViewController.results = results
            }
        }
    }
    private func alert() {
        let  confirmationAlert = UIAlertController(title: "No internet connection detected" , message: "Please check your internet connection and try again", preferredStyle: .actionSheet)
        confirmationAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action : UIAlertAction!) in }))
        
        present(confirmationAlert,animated: true, completion: nil)
    }
    
}
