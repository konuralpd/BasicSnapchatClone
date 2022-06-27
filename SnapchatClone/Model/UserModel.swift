//
//  UserModel.swift
//  SnapchatClone
//
//  Created by Mac on 12.06.2022.
//

import Foundation



class UserModel {
    
    static let sharedUserInfo = UserModel()
    
    var email = ""
    var username = ""
    
    private init() {
        
        
    }
}
