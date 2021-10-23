//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Ömer Faruk KÖSE on 22.10.2021.
//

import UIKit

class SignViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpClicked(_ sender: Any) {
    }
    @IBAction func signInClicked(_ sender: Any) {
        performSegue(withIdentifier: "toPlacesTableVC", sender: nil)
    }
    
}

