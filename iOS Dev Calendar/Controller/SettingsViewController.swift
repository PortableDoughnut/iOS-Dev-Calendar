//
//  SettingsViewController.swift
//  iOS Dev Calendar
//
//  Created by Jane Madsen on 6/11/25.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var cohortSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedCohort = UserDefaults.standard.string(forKey: "selectedCohort")
        
        cohortSegmentedControl.selectedSegmentIndex = savedCohort == "fall" ? 0 : 1
    }
    
    func saveSelectedCohort() {
        let selectedCohort = cohortSegmentedControl.selectedSegmentIndex == 0 ? "fall" : "winter"
        UserDefaults.standard.set(selectedCohort, forKey: "selectedCohort")
    }
    
    @IBAction func updateCohort(_ sender: Any) {
        saveSelectedCohort()
        Task {
            try? await DataRepository.shared.loadRemoteData()
        }
    }
}
