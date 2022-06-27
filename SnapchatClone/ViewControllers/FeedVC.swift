//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Mac on 12.06.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
   
    
    
    
    let fireStoreDatabase = Firestore.firestore()
    
    var snapArray = [Snap]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        getSnapsFromFirebas()
        
    }
    
    
    func getUInfo() {
        
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
                
                
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        if let username = document.get("username") as? String {
                            
                            UserModel.sharedUserInfo.email = Auth.auth().currentUser!.email! 
                            UserModel.sharedUserInfo.username = username
                        }
                    }
                }
                
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.feedUsernameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
    func getSnapsFromFirebas() {
        
        fireStoreDatabase.collection("Snaps").order(by: "data", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrl") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        
                                        if difference >= 24 {
                                            
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { error in
                                                print(error?.localizedDescription)
                                            }
                                        }
                                    }
                                    
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                                    self.snapArray.append(snap)
                                    
                                }
                            }
                        }
                        
                    }
                    self.tableView.reloadData()
                }
               
            }
        }
    }
    

}
