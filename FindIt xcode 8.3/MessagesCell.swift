//
//  MessagesCell.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 01/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    let userName: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "Avenir Next", size: 16)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let lastMessage: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    func userNameConstraints(){
        userName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        userName.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        userName.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier: 0.9).isActive = true
        userName.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        
        lastMessage.leftAnchor.constraint(equalTo: userName.leftAnchor).isActive = true
        lastMessage.topAnchor.constraint(equalTo: userName.bottomAnchor).isActive = true
        lastMessage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 8).isActive = true
        lastMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(userName)
        addSubview(lastMessage)
        userNameConstraints()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
