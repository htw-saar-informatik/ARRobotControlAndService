//
//  Me.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import Foundation
import FirebaseAuth

// Helper class to access current user object
class Me {
    // computed property which returns the current user id
    static var uid: String {
        return Auth.auth().currentUser!.uid
    }
    
    // retrieves the username for the current user object
    static func mail(completion: @escaping (String?)->()){
        User.loadUser(userId: Me.uid, completion: { (user) in
            if let user = user{
                completion(user.mail)
            }else{
                completion(nil)
            }
        }) {
            completion(nil)
        }
    }
}
