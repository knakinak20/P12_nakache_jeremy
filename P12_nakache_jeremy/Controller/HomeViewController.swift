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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func getResult(_ sender: Any) {
        getResultData()
    }
    func getCurrentShortDate() {
        let todaysDate = NSDate()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateToday = dateFormatter.string(from: todaysDate as Date)
    }
    
    private func getResultData() {
        getCurrentShortDate()
        
        resultRepository.getResults(endPoint: "fixtures?date=\(dateToday)&timezone=Europe/Paris") { [weak self] result in
            DispatchQueue.main.async {
                self?.results = result.response
                self?.performSegue(withIdentifier: "SegueToResultDay", sender: self)
                
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
    
}
