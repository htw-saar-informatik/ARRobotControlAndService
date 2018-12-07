//
//  Roboter.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Roboter{
    var name : String
    var content : [String:Any]
    
    var dictionary : [String:Any] {
        return[
            "name": name,
            "content" : content
        ]
    }
}

extension Roboter : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let content = dictionary["content"] as? [String:Any] else {return nil}
        
        self.init(name: name, content: content)
    }
}
