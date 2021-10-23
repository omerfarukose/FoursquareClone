//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Ömer Faruk KÖSE on 22.10.2021.
//

import UIKit
import Parse

class SignViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*
      
       */
        
        
    }

    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameField.text != nil && passwordField.text  != nil {
            let user = PFUser()
            user.username = usernameField.text
            user.password = passwordField.text
            user.signUpInBackground { succes, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Sign Up Error !")
                }else{
                    self.makeAlert(title: "Succes", message: "Sign Up Successful.")
                }
            }
        }else{
            makeAlert(title: "Error !", message: "Enter Username&Password")
        }
            
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if usernameField.text != "" && passwordField.text != "" {
            PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user, error) in
                if error != nil {
                    self.makeAlert(title: "Sign In Error", message: error?.localizedDescription ?? "Sign In Error !")
                }else{
                    self.performSegue(withIdentifier: "toPlacesTableVC", sender: nil)
                }
            }
        }else{
            makeAlert(title: "Error !", message: "Enter Username&Password")
        }
        
        
    }
    
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

