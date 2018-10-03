//
//  Message.swift
//  wChat
//
//  Created by Julian Capeloni on 7/7/18.
//  Copyright © 2018 Julian Capeloni. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromId: String?
    var text: String?
    var timeStamp: NSNumber?
    var toId: String?
    var imageUrl: String?
   
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.timeStamp = dictionary["timeStamp"] as? NSNumber
        self.toId = dictionary["toId"] as? String
        self.imageUrl = dictionary["imageUrl"] as? String
    }
 
    func chatPartnerId() -> String? {
//Metodo corto nuevo segun video, reemplaza al if de abajo
    return fromId == Auth.auth().currentUser?.uid ? toId : fromId
/*
    if fromId == Auth.auth().currentUser?.uid {
        return toId
    }else{
        return fromId
    }
*/
    }
}
