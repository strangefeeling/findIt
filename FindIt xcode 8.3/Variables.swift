//
//  Variables.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 25/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

var postName = String()

var postNames = [String]()

var messagesInPost = [String]()

var imageUrl = String()

var doINeedToSearch = false

var foundCity = "Vilnius"

var myTextColor = UIColor.white// UIColor(red: 127/255, green: 25/255, blue: 23/255, alpha: 1)

//var patternImage = UIImage(named: "iPhone 7 Plus1")

var toIdd = ""

var foundOrLost = "lost"

let myColor =  UIColor(red: 140/255, green: 212/255, blue: 141/255, alpha: 1)//UIColor(red: 255/255, green: 246/255, blue: 243/255, alpha: 1)//UIColor(red: 140/255, green: 212/255, blue: 141/255, alpha: 1)//(red: 78/255, green: 128/255, blue: 173/255, alpha: 1)//(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)



var descriptiontextField: UILabel = {
    let textField = UILabel()
    textField.text = "sadhbjkasfaksfnaklsvnzkcnaskfnsakjnakscnascnadskjnsdkjvndmnz,mcvn"
    textField.font = UIFont(name: "Avenir Next", size: 18)
    textField.layer.cornerRadius = 10
    textField.numberOfLines = 0
    textField.sizeToFit()
    textField.textAlignment = .center
    return textField
}()

var image: UIImageView = {
    let image = UIImageView()
    // image.backgroundColor = .red
    image.contentMode = .top
    return image
}()

var cityLabel: UILabel = {
    let label = UILabel()
    label.text = "Name"
    label.textAlignment = .left
    label.sizeToFit()
    //label.backgroundColor = .green
    label.textColor = .darkGray
    label.font = UIFont(name: "Avenir Next-Bold", size: 20)
   // label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

var locationLabel: UILabel = {
    let label = UILabel()
    label.text = "Location"
    label.textAlignment = .left
    label.sizeToFit()
   // label.backgroundColor = .cyan
    label.textColor = .darkGray
    label.font = UIFont(name: "Avenir Next-Bold", size: 20)
    //label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

var dateLabel: UILabel = {
    let label = UILabel()
    label.text = "2017"
    label.textAlignment = .left
    label.sizeToFit()
    
    label.textColor = .lightGray
    label.font = UIFont(name: "Avenir Next-Bold", size: 20)
    //label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

var posterUid: UILabel = {
    var uid = UILabel()
    //uid.translatesAutoresizingMaskIntoConstraints = false
    uid.sizeToFit()
    //uid.backgroundColor = .yellow
    uid.font = UIFont(name: "Avenir Next", size: 20)
    uid.textColor = .darkGray
    
    return uid
}()
