//
//  InfoCell.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 26/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit


class InfoCell: UICollectionViewCell {
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.text = "LLaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        tv.translatesAutoresizingMaskIntoConstraints = false
        // kad bubble matytus
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.textColor = .white
        return tv
    }()
    
    var id = String()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    let bubbleView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        bv.layer.cornerRadius = 16
        bv.layer.masksToBounds = true
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    
    
    //kad rodytu
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        bubbleWidthAnchor =  bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        // -----right
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)//.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //  textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 0).isActive = true
        // textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
