//
//  AllItemsTableViewCell.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 24/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class AllItemsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        makeConstraints()
       /* contentView.addSubview(infoLabel)
        contentView.backgroundColor = .red
        infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        infoLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
 */   
 }

    let allUsers = EveryUser()
    
    var womanImage: UIImageView = {
        let wI = UIImageView()
        
        //  wI.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 0.9, height: UIScreen.main.bounds.height / 2.2)
        wI.contentMode = .scaleAspectFit
        wI.translatesAutoresizingMaskIntoConstraints = false
        return wI
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Message"
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Vilnius"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.font = UIFont(name: "Avenir Next-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2017"
        label.textAlignment = .left
        label.sizeToFit()
        
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir Next-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .left
        label.sizeToFit()
        
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityWord: UILabel = {
        let label = UILabel()
        label.text = "City: "
        label.textAlignment = .left
        label.sizeToFit()
        
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationWord: UILabel = {
        let label = UILabel()
        label.text = "Street: "
        label.textAlignment = .left
        label.sizeToFit()
        
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "by: You"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.textAlignment = .left
        label.sizeToFit()
        
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemDescription: UITextView = {
        let iD = UITextView()
        let borderColor = UIColor.darkGray
        iD.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 0.9, height: UIScreen.main.bounds.height / 2.2)
        iD.translatesAutoresizingMaskIntoConstraints = false
        iD.text = "TEST"
        iD.textAlignment = .center
        iD.isEditable = false
        iD.layer.borderWidth = 1
        iD.layer.borderColor = borderColor.cgColor
        iD.layer.cornerRadius = 10
        iD.font = UIFont(name: "Avenir Next", size: 24)
        
        return iD
    }()
    
    let blankView = UIView()
    
    let separatorLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .darkGray
        return line
    }()
    
    func makeConstraints(){
        //contentView.addSubview(itemDescription)
        // contentView.addSubview(descriptionLabel)
        contentView.addSubview(womanImage)
        contentView.addSubview(locationWord)
        contentView.addSubview(locationLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(cityWord)
        contentView.addSubview(dateLabel)
        contentView.addSubview(nameLabel)

       /*
        
       
        
        */
        // contentView.addSubview(separatorLine)
        
      
        
        womanImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48).isActive = true
        womanImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        womanImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        womanImage.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        nameLabel.bottomAnchor.constraint(equalTo: womanImage.topAnchor, constant: -8).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: womanImage.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        infoLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        infoLabel.topAnchor.constraint(equalTo: womanImage.bottomAnchor, constant: 48).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        //infoLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        

        
        cityWord.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        cityWord.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cityWord.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 24).isActive = true
        //locationWord.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        cityLabel.leftAnchor.constraint(equalTo: cityWord.rightAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: cityWord.topAnchor).isActive = true
        cityLabel.heightAnchor.constraint(equalTo: cityWord.heightAnchor).isActive = true
        
        locationWord.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        locationWord.heightAnchor.constraint(equalTo: cityWord.heightAnchor).isActive = true
        locationWord.topAnchor.constraint(equalTo: cityWord.bottomAnchor, constant: 4).isActive = true
        
        locationLabel.leftAnchor.constraint(equalTo: locationWord.rightAnchor, constant: 0).isActive = true
        locationLabel.topAnchor.constraint(equalTo: locationWord.topAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalTo: locationWord.heightAnchor).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: locationWord.bottomAnchor, constant: 8).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: locationWord.heightAnchor).isActive = true
        
       /*
        
        
       
        
       
        
        
        
        
        
        //  separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        // separatorLine.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0).isActive = true
        // separatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        //separatorLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
     */
    }

  
}
