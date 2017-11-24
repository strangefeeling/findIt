//
//  MyItemsCell.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 12/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class MyItemsCell: UICollectionViewCell {
    let colorBlue  = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    let stackView = UIStackView()
    let stackView2 = UIStackView()
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
        label.font = UIFont(name: "Avenir Next-Bold", size: 20)
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
    
    
    /*   override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
     if UIDevice.current.orientation.isLandscape {
     
     stackView.axis = .horizontal
     } else if contentView.traitCollection.horizontalSizeClass == .compact{
     stackView.axis = .vertical
     }
     }*/
    
    
    
    /*    override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
     let myCell = MyItemsCell()
     print("transition occured")
     if UIDevice.current.orientation.isLandscape {
     myCell.stackView.axis = .horizontal
     }  else{
     myCell.stackView.axis = .vertical
     }
     }*/
    
    func makeConstraints(){
        //contentView.addSubview(itemDescription)
       // contentView.addSubview(descriptionLabel)
        contentView.addSubview(womanImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(cityWord)
        contentView.addSubview(locationWord)
        contentView.addSubview(dateLabel)
       // contentView.addSubview(separatorLine)
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        womanImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        womanImage.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 8).isActive = true
        womanImage.rightAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: -8).isActive = true
        womanImage.heightAnchor.constraint(equalToConstant: 220).isActive = true

        infoLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        infoLabel.topAnchor.constraint(equalTo: womanImage.bottomAnchor, constant: 48).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        //infoLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        cityWord.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 32).isActive = true
        cityWord.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        //locationLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        cityWord.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        cityLabel.leftAnchor.constraint(equalTo: cityWord.rightAnchor, constant: 0).isActive = true
        cityLabel.topAnchor.constraint(equalTo: cityWord.topAnchor).isActive = true
        cityLabel.heightAnchor.constraint(equalTo: cityWord.heightAnchor).isActive = true
        
        locationWord.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        locationWord.heightAnchor.constraint(equalToConstant: 20).isActive = true
        locationWord.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8).isActive = true
        
        locationLabel.leftAnchor.constraint(equalTo: locationWord.rightAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: locationWord.topAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalTo: locationWord.heightAnchor).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: locationWord.bottomAnchor, constant: 8).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: locationWord.heightAnchor).isActive = true
        
      //  separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
       // separatorLine.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0).isActive = true
       // separatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        //separatorLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
    }
    
    func handleConstraints(){
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20).isActive = true
        
        stackView2.addArrangedSubview(blankView)
        
        blankView.addSubview(itemDescription)
        blankView.addSubview(descriptionLabel)
        //  blankView.addSubview(saveButton)
        stackView.axis = .vertical
        itemDescription.widthAnchor.constraint(equalTo: blankView.widthAnchor, multiplier: 0.9).isActive = true
        itemDescription.heightAnchor.constraint(equalTo: blankView.heightAnchor, multiplier: 0.4).isActive = true
        itemDescription.centerXAnchor.constraint(equalTo: blankView.centerXAnchor).isActive = true
        itemDescription.centerYAnchor.constraint(equalTo: blankView.centerYAnchor, constant: 0).isActive = true
        
        descriptionLabel.leftAnchor.constraint(equalTo: itemDescription.leftAnchor, constant: 0).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: itemDescription.topAnchor, constant: -8).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        stackView2.distribution = .fillEqually
        stackView.addArrangedSubview(womanImage)
        stackView.addArrangedSubview(stackView2)
        stackView.distribution = .fillEqually
        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    
    
    /* override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
     if UIDevice.current.orientation.isLandscape {
     stackView.axis = .horizontal
     //handleConstraints()
     } else {
     stackView.axis = .vertical
     //  handleConstraints()
     }
     }*/
    
    
    func congigureCell(text: String) {
        infoLabel.text = text
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .white
        //contentView.addSubview(stackView)
        //handleConstraints()
        makeConstraints()
    }
}
