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
    private var league = [String]()
    private var fixture = [Int]()
    private var leagueFixture = [Any]()
    private var dateToday = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func getResult(_ sender: Any) {
        getResultData()
        
    }
    private func getCurrentShortDate() {
        let todaysDate = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateToday = dateFormatter.string(from: todaysDate as Date)
    }
    
    private func getResultData() {
        getCurrentShortDate()
        
        resultRepository.getResults(endPoint: "fixtures?date=\(dateToday)&timezone=Europe/Paris") { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let matchResult) :
                self?.results = matchResult.response
                self?.performSegue(withIdentifier: "SegueToResultDay", sender: self)
                    
                case .failure(_):
                    print("alert")
                    break
            }
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
