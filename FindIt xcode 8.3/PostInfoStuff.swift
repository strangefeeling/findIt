//
//  PostInfoStuff.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 22/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class PostInfoStuff: UITableViewCell {

    
    var imagee: UIImageView = {
        let image = UIImageView()
        // image.backgroundColor = .red
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let commentsLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Avenir Next-Bold", size: 16)
        label.text = "Comments:"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        return label
    }()
        
    var locationLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.sizeToFit()
        
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next-Bold", size: 16)
        label.sizeToFit()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.sizeToFit()
        
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir Next-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var cityLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.sizeToFit()
        
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cityWord: UILabel = {
        let label = UILabel()
        label.text = "City: "
        label.textAlignment = .left
        label.sizeToFit()
        
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var locationWord: UILabel = {
        let label = UILabel()
        label.text = "Street: "
        label.textAlignment = .left
        label.sizeToFit()
        
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var posterUid: UILabel = {
        var uid = UILabel()
        uid.translatesAutoresizingMaskIntoConstraints = false
        uid.sizeToFit()
        //uid.backgroundColor = .yellow
        uid.font = UIFont(name: "Avenir Next", size: 16)
        uid.textColor = .darkGray
        
        return uid
    }()
    
    let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    var descriptiontextField: UILabel = {
        let textField = UILabel()
        
        textField.font = UIFont(name: "Avenir Next", size: 16)
        textField.numberOfLines = 0
        
        textField.sizeToFit()
        textField.textAlignment = .center
        return textField
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    func setupView(){
        
        contentView.addSubview(imagee)
        contentView.addSubview(posterUid)
        contentView.addSubview(descriptiontextField)
        contentView.addSubview(cityWord)
        contentView.addSubview(cityLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(locationWord)
        contentView.addSubview(dateLabel)
        contentView.addSubview(commentsLabel)
        contentView.addSubview(separatorLine)
        
        
        
        posterUid.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        posterUid.heightAnchor.constraint(equalToConstant: 24).isActive = true
        posterUid.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
        
        
        
        imagee.translatesAutoresizingMaskIntoConstraints = false
        imagee.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        imagee.topAnchor.constraint(equalTo: posterUid.bottomAnchor, constant: 4).isActive = true
        imagee.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imagee.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        descriptiontextField.translatesAutoresizingMaskIntoConstraints = false
        descriptiontextField.topAnchor.constraint(equalTo: imagee.bottomAnchor, constant: 16).isActive = true
        descriptiontextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        descriptiontextField.rightAnchor.constraint(equalTo: imagee.rightAnchor, constant: -16).isActive = true
        
        
        cityWord.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        cityWord.topAnchor.constraint(equalTo: descriptiontextField.bottomAnchor, constant: 8).isActive = true
        cityWord.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        cityLabel.leftAnchor.constraint(equalTo: cityWord.rightAnchor).isActive = true
        cityLabel.heightAnchor.constraint(equalTo: cityWord.heightAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: cityWord.topAnchor).isActive = true
        
        locationWord.leftAnchor.constraint(equalTo: cityWord.leftAnchor).isActive = true
        locationWord.topAnchor.constraint(equalTo: cityWord.bottomAnchor, constant: 4).isActive = true
        locationWord.heightAnchor.constraint(equalTo: cityWord.heightAnchor).isActive = true
        
        locationLabel.leftAnchor.constraint(equalTo: locationWord.rightAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: locationWord.topAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalTo: locationWord.heightAnchor).isActive = true
        
        
        dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8).isActive = true
        
        commentsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4).isActive = true
        commentsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        
        separatorLine.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 0).isActive = true
        separatorLine.leftAnchor.constraint(equalTo: commentsLabel.leftAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    

   
}
