//
//  loginViewController.swift
//  Parstagram
//
//  Created by Spencer Steggell on 3/17/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onSignIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.usernameField.text!, password: self.passwordField.text!) {
                  (user: PFUser?, error: Error?) -> Void in
                  if user != nil {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                  } else {
                    self.displayAlert(withTitle: "Error", message: error!.localizedDescription)
                      print("Error: \(String(describing: error?.localizedDescription))")
                  }
                }
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
                user.username = self.usernameField.text
                user.password = self.passwordField.text

                
                user.signUpInBackground {(succeeded: Bool, error: Error?) -> Void in
                    if let error = error {
                        self.displayAlert(withTitle: "Error", message: error.localizedDescription)
                        print("Error: \(String(describing: error.localizedDescription))")
                    } else {
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                }
    }
    
    
    
    func displayAlert(withTitle title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
