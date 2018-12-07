//
//  FirebaseHelper.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase

struct FirebaseHelper{
    private static var db: Firestore = Firestore.firestore()
    
    static func getDB() -> Firestore {
        return db
    }
}
