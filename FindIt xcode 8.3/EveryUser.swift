//
//  EveryUser.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 13/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class EveryUser: NSObject {
    
    var toId = String()
    var postName = [String]()
    var downloadUrls = [String]()
    var descriptions = [String]()
    var dictionary = ["description": String(),"downloadUrls": String(), "timeStamp": Int()] as [String : Any]
    var timeStamp = [Int]()
    var uid = [String]()
    var date = [Double]()
    var location = [String]()
    var city = [String]()
    var email = [String]()
}

