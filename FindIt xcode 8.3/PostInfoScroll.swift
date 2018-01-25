//
//  PostInfoScroll.swift
//  FindIt xcode 8.3
//
//  Created by rytis razmus on 25/01/2018.
//  Copyright © 2018 Rytis. All rights reserved.
//

import UIKit

class PostInfoScroll: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(infoLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        infoLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }

    
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
        label.textAlignment = .left
        label.textColor = .darkGray
        //label.backgroundColor = UIColor(red: 249/255, green: 247/255, blue: 252/255, alpha: 1)
        //label.numberOfLines = 2
        label.font = UIFont(name: "Avenir Next-Bold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2000)
        scrollView.backgroundColor = .green
        return scrollView
    }()
    
}
