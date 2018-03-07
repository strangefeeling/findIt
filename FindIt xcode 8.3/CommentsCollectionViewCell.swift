//
//  CommentsCollectionViewCell.swift
//  FindIt xcode 8.3
//
//  Created by rytis razmus on 05/03/2018.
//  Copyright © 2018 Rytis. All rights reserved.
//

import UIKit

class CommentsCollectionViewCell: UICollectionViewCell {
    
    let comment: UILabel = {
       let label = UILabel()
      
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let separtorLineTop: UIView = {
       let view = UIView()
        
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let separtorLineBottom: UIView = {
        let view = UIView()
        
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        
        label.text = "name"
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "2018-03-05"
        label.textAlignment = .center
        //label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    override func awakeFromNib() {
        contentView.backgroundColor = UIColor(red: 1, green: 205/255, blue: 0, alpha: 1)
        contentView.addSubview(comment)
        
        contentView.addSubview(separtorLineTop)
        
        separtorLineTop.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        separtorLineTop.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        separtorLineTop.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        separtorLineTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        
        contentView.addSubview(dateLabel)
        dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        comment.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        comment.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 8).isActive = true
        comment.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
        comment.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        
        contentView.addSubview(separtorLineBottom)
        
        separtorLineBottom.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        separtorLineBottom.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        separtorLineBottom.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        separtorLineBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
}
