//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Mac on 12.06.2022.
//

import UIKit
import FirebaseStorage
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var fotografYaziView: UIView!
    @IBOutlet weak var viewYaziView: UIView!
    @IBOutlet weak var uploadImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        fotografYaziView.layer.cornerRadius = 30
        viewYaziView.layer.cornerRadius = 30
        
        
        fotografYaziView.layer.shadowColor = UIColor.white.cgColor
        fotografYaziView.layer.shadowRadius = 55.0
        fotografYaziView.layer.shadowOpacity = 0.4
        fotografYaziView.layer.shadowOffset = CGSize(width: 3, height: 3)
        fotografYaziView.layer.masksToBounds = false
        
        
        viewYaziView.layer.shadowColor = UIColor.white.cgColor
        viewYaziView.layer.shadowRadius = 55.0
        viewYaziView.layer.shadowOpacity = 0.4
        viewYaziView.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewYaziView.layer.masksToBounds = false
        
        
        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        uploadImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func choosePicture() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        //picker.sourceType = .camera
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func uploadBtnTiklandi(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            let fireStore = Firestore.firestore()
                            
                            let snapDictionary = ["imageUrl" : imageUrl!, "snapOwner" : UserModel.sharedUserInfo.username, "date" : FieldValue.serverTimestamp()] as [String : Any]
                            
                            fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                if error != nil {
                                    print(error?.localizedDescription)
                                    
                                } else {
                                    
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    @IBAction func kapatButonTiklandi(_ sender: Any) {
       
       

    }
    
}
