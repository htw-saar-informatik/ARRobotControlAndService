//
//  User.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FirebaseFirestore
import SwiftyJSON

enum UpdateStatus{
    case initalWrite, update
}


struct User{
    var id: String
    var mail: String
    var mode: String?
    
    init(id: String, mail:String){
        self.id = id
        self.mail = mail
    }
    
    private static func createUserFromJson(userId: String, data: JSON) -> User?{
        let data = data.dictionaryValue
        let metadata = data["metadata"]?.dictionaryValue
        
        guard let meta = metadata else {return nil}
        
        let mail = meta["mail"]?.stringValue
        
        let user: User = User(id: userId, mail: mail!)
        
        return user
    }
    
    static func loadUser(userId: String, completion: @escaping (User?)->(), fail: @escaping ()->()){
        let userRef = FirebaseHelper.getDB().document(userId)
        userRef.getDocument{(document, error) in
            if document != nil
            {
                let data = JSON(document!)
                let user = createUserFromJson(userId: userId, data: data)
                if let user = user {
                    completion(user)
                }
                else
                {
                    fail()
                }
            }
        }
    }
    
    func save(){
        let jsonUser = toJson(mode: .initalWrite)
        let userRef = FirebaseHelper.getDB().collection("user").document(Me.uid).setData(jsonUser)
        
    
    }
}

extension User {
    private func getMetadataJson(_ mode: UpdateStatus) -> [String:Any]{
        var metadataJson: [String:Any] = [
            "mail": self.mail,
            "updated": NSDate()
        ]
        
        if mode == .initalWrite
        {
            metadataJson["created"] = NSDate()
        }
        return metadataJson
    }
    
    func toJson(mode: UpdateStatus) -> [String:Any]{
        let metadataJson = getMetadataJson(mode)
        let userJson:[String:Any] = [
            "metadata" : metadataJson
        ]
        
        return userJson
    }
}
