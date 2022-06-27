//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Mac on 12.06.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInVC: UIViewController {
   
   
    
    @IBOutlet weak var logoImage: UIImageView!
    
  
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImage.layer.shadowColor = UIColor.black.cgColor
        logoImage.layer.shadowRadius = 5.0
        logoImage.layer.shadowOpacity = 0.3
        logoImage.layer.shadowOffset = CGSize(width: 4, height: 4)
        logoImage.layer.masksToBounds = false
       
        emailField.layer.shadowColor = UIColor.black.cgColor
        emailField.layer.shadowRadius = 5.0
        emailField.layer.shadowOpacity = 0.3
        emailField.layer.shadowOffset = CGSize(width: 4, height: 4)
        emailField.layer.masksToBounds = false
        
        usernameField.layer.shadowColor = UIColor.black.cgColor
        usernameField.layer.shadowRadius = 5.0
        usernameField.layer.shadowOpacity = 0.3
        usernameField.layer.shadowOffset = CGSize(width: 4, height: 4)
        usernameField.layer.masksToBounds = false
        
        passwordField.layer.shadowColor = UIColor.black.cgColor
        passwordField.layer.shadowRadius = 5.0
        passwordField.layer.shadowOpacity = 0.3
        passwordField.layer.shadowOffset = CGSize(width: 4, height: 4)
        passwordField.layer.masksToBounds = false
        
        
        

        
        
        view.backgroundColor = UIColor(red: 255, green: 252, blue: 0, alpha: 1)
    }

    
    @IBAction func girisBtnTiklandi(_ sender: Any) {
        
        if usernameField.text != "" && passwordField.text != "" && emailField.text != "" {
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { result, error in
                
                if error != nil {
                    
                    self.makeAlert(title: "Hata", message: "Hata")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
            
        } else {
            self.makeAlert(title: "Hata", message: "Hata")
        }
        
    }
    
    
    @IBAction func kayitBtnTiklandi(_ sender: Any) {
        
        if usernameField.text != "" && passwordField.text != "" && emailField.text != "" {
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { auth, error in
                if error != nil {
                    
                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                } else {
                    
                    let fireStore = Firestore.firestore()
                    
                    let userDictionary = ["email" : self.emailField.text!, "username" : self.usernameField.text!] as [String : Any]
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                            
                            
                        }
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            
            self.makeAlert(title: "Hata", message: "Girilen Bilgilerde Hata Var")
        }
        
    }
    
    func makeAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    

}

