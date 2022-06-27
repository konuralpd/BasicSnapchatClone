//
//  SettingVC.swift
//  SnapchatClone
//
//  Created by Mac on 12.06.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingVC: UIViewController {

    @IBOutlet weak var oturumuKapatView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        oturumuKapatView.layer.cornerRadius = 30
        
        
        oturumuKapatView.layer.shadowColor = UIColor.white.cgColor
        oturumuKapatView.layer.shadowRadius = 55.0
        oturumuKapatView.layer.shadowOpacity = 0.4
        oturumuKapatView.layer.shadowOffset = CGSize(width: 3, height: 3)
        oturumuKapatView.layer.masksToBounds = false
        oturumuKapatView.layer.opacity = 0.5
        
    }
    

    @IBAction func cikisTiklandi(_ sender: Any) {
        
        do { try Auth.auth().signOut() }
          catch { print("already logged out") }
          
        performSegue(withIdentifier: "toSigninVC", sender: nil)
        
    }
    
    @IBAction func kapatButonTiklandi(_ sender: Any) {
        
        

    }
    
}
