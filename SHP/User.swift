//
//  User.swift
//  SHP
//
//  Created by Mark Sandomeno on 5/6/17.
//  Copyright © 2017 SandoStudios. All rights reserved.
//

import UIKit

class User: NSObject {
    
    //user components
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    var AClass: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.AClass = dictionary["AClass"] as? String
    }
}

