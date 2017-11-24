//
//  MoreCell.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 07/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class MoreCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        handleConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let text: UILabel = {
       let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false

        return text
    }()
    
    func handleConstraints(){
        addSubview(text)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: text)
        addConstraintsWithFormat(format: "V:|[v0]|", views: text)
    }
    
}
