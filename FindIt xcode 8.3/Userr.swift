//
//  Userr.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 12/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class Userr: NSObject {
    var id: String?
    var postName = [String]()
    var email: String?
    var uid = [String]()
    var profileImageUrl: String?
    var downloadUrls = [String]()
    var descriptions = [String]()
    var dictionary = ["description": String(),"downloadUrls": String(), "timeStamp": Int()] as [String : Any]
    var timeStamp = [Int]()
}
