//
//  Users.swift
//  wChat
//
//  Created by Julian Capeloni on 23/5/18.
//  Copyright © 2018 Julian Capeloni. All rights reserved.
//

import UIKit

class Users: NSObject {
    var name: String?
    var email: String?
    var profileImageURL: String?
    var id: String?
   init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageUrl"] as? String ?? ""
//        self.id = dictionary["id"] as? String ?? ""
//        self.profileImageURL = dictionary["profileImageUrl"] as? String ?? ""
}
}
