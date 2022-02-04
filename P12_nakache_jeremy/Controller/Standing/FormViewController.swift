//
//  FormViewController.swift
//  P12_nakache_jeremy
//
//  Created by user on 24/01/2022.
//

import UIKit

class FormViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var pickerViewData = PickerViewData()
    private var repositoryStanding = StandingsRepository()
    private var standings = [Standing]()
    private var selectedLigue = ""
    private var selectedLigueId = 0
    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // not sure if necessary
        pickerView.reloadAllComponents()
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
    }
    
    // Nombre de colonne dans le pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerViewData.countryPickerData.count
        } else {
            let selectedRowInFirstComponent = pickerView.selectedRow(inComponent: 0)
            return pickerViewData.countryPickerData[selectedRowInFirstComponent].1.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            // refresh and reset 2nd component everytime another 1st component is chosen
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            
            // return the first value of the tuple (so the category name) at index row
            return pickerViewData.countryPickerData[row].0
        } else {
            // component is 1, so we look which row is selected in the first component
            let selectedRowInFirstComponent = pickerView.selectedRow(inComponent: 0)
            
            // we check if the selected row is the minimum of the given row index and the amount of elements in a given category tuple array
            let safeRowIndex = min(row, (pickerViewData.countryPickerData[selectedRowInFirstComponent].1.count)-1)
            return pickerViewData.countryPickerData[selectedRowInFirstComponent].1[safeRowIndex]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: false)
        }
        if component == 1 {
            
            let selection1 = pickerView.selectedRow(inComponent: 0)
            let selection2 = pickerView.selectedRow(inComponent: 1)
            let dataArray = pickerViewData.countryPickerData[selection1]
            let dataArraySelected = dataArray.1
            let selectedrow = dataArraySelected[selection2]
            selectedLigue = selectedrow
            getIdLeague(with: selectedLigue)
        }
    }
    
    @IBAction func tapbutton(_ sender: Any) {
        getStanding()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? StandingViewController {
            nextViewController.standings = standings
            nextViewController.selectedLigue = selectedLigue
        }
    }
    
    
    private func getStanding() {
        repositoryStanding.getDataStandings(endPoint: "standings?league=\(selectedLigueId)&season=2021") { result in
            DispatchQueue.main.async {
                if let response = result.response.first?.league.standings?.first {
                    self.standings = response.compactMap { $0.self}
                    self.performSegue(withIdentifier: "segueToStanding", sender: nil)
                    
                }
            }
        }
    }
    private func getIdLeague (with selectedLeague : String) {
        switch selectedLeague {
        case "La Liga":
            selectedLigueId = 140
        case "Segunda Division":
            selectedLigueId = 269
        case "Primera Division Women":
            selectedLigueId = 142
        case "Premier League":
            selectedLigueId = 39
        case "Championship":
            selectedLigueId = 40
        case "National League":
            selectedLigueId = 43
        case "Women's Championship":
            selectedLigueId = 699
        case "Serie A":
            selectedLigueId = 135
        case "Serie B":
            selectedLigueId = 136
        case "Serie C":
            selectedLigueId = 138
        case "Serie A Women":
            selectedLigueId = 139
        case "Primera Division":
            selectedLigueId = 128
        case "Torneo Federal A":
            selectedLigueId = 134
        case "Primera C":
            selectedLigueId = 132
        case "Primera B Nacional":
            selectedLigueId = 129
        case "ligue 1":
            selectedLigueId = 61
        case "ligue 2":
            selectedLigueId = 62
        case "National":
            selectedLigueId = 63
        case "Feminine Division 1":
            selectedLigueId = 64
        case "Bundesliga 1":
            selectedLigueId = 78
        case "Bundesliga 2":
            selectedLigueId = 79
        case "Liga 3":
            selectedLigueId = 80
        case "Women Bundesliga":
            selectedLigueId = 82
        case "Eredivisie":
            selectedLigueId = 88
        case "Eredivisie Women":
            selectedLigueId = 91
        case "Primeira Liga":
            selectedLigueId = 94
        case "Liga de Honra":
            selectedLigueId = 95
        default:
            print ("alert") // to do
        }
    }
}


