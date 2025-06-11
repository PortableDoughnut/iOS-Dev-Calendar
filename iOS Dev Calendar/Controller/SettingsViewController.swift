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
        
        let savedCohort = UserDefaults.value(forKey: "selectedCohort")
        
        cohortSegmentedControl.selectedSegmentIndex = savedCohort as? String == "fall" ? 0 : 1
    }
    
    func saveSelectedCohort() {
        let selectedCohort = cohortSegmentedControl.selectedSegmentIndex == 0 ? "fall" : "winter"
        UserDefaults.setValue(selectedCohort, forKey: "selectedCohort")
    }
    
    @IBAction func updateCohort(_ sender: Any) {
        saveSelectedCohort()
    }
}
