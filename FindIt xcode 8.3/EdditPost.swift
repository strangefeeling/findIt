//
//  edditPost.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 13/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//
/*
import UIKit
import Firebase

class EdditPost: UIViewController {
    
    var selectedPost: Int?
    var myDescriptions = [String]()
    var postName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  self.getData()
        
        navigationItem.title = "Edit Post"
        
        deviceRotation()
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        
        handleConstraints()
        
        
    }
    
    func deviceRotation(){
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
    }
    
    
    
    let saveButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Save", for: .normal)
        bt.setTitleColor(.red, for: .normal)
        bt.titleLabel?.font = UIFont(name: "Anevir Next", size: 20)
        bt.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return bt
    }()
    
    @objc func handleSave(){
      
        let ref =  Database.database().reference().child("allPosts").child(postName)
        
       
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        ref.child("description").setValue(self.itemDescription.text!)
        ref.child("timeStamp").setValue(timeStamp)
        self.myDescriptions.append(self.itemDescription.text!)
        DispatchQueue.main.async {
            //go back
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
    
    
    let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height ))
    let stackView2 = UIStackView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: ((UIScreen.main.bounds.height ) / CGFloat(2))))
    
    let womanImage: UIImageView = {
        let wI = UIImageView()
        
        wI.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 0.9, height: UIScreen.main.bounds.height / 2.2)
        wI.contentMode = .scaleAspectFit
        wI.translatesAutoresizingMaskIntoConstraints = false
        return wI
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        // label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 0.9, height: UIScreen.main.bounds.height / 2.2)
        label.text = "Message"
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        // label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height )
        return label
    }()
    
    
    
    let itemDescription: UITextView = {
        let iD = UITextView()
        let borderColor = UIColor.darkGray
        iD.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 0.9, height: UIScreen.main.bounds.height / 2.2)
        iD.translatesAutoresizingMaskIntoConstraints = false
        iD.text = "TEST"
        iD.textAlignment = .center
        iD.layer.borderWidth = 1
        iD.layer.borderColor = borderColor.cgColor
        iD.layer.cornerRadius = 10
        //  iD.font = UIFont.systemFont(ofSize: 24)
        iD.font = UIFont(name: "Avenir Next", size: 24)
        // iD.backgroundColor = .yellow
        
        return iD
    }()
    
    let blankView = UIView()
    
    func handleConstraints(){
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        
        stackView2.addArrangedSubview(blankView)
        
        blankView.addSubview(itemDescription)
        blankView.addSubview(descriptionLabel)
        blankView.addSubview(saveButton)
        
        itemDescription.widthAnchor.constraint(equalTo: blankView.widthAnchor, multiplier: 0.9).isActive = true
        itemDescription.heightAnchor.constraint(equalTo: blankView.heightAnchor, multiplier: 0.4).isActive = true
        itemDescription.centerXAnchor.constraint(equalTo: blankView.centerXAnchor).isActive = true
        itemDescription.centerYAnchor.constraint(equalTo: blankView.centerYAnchor, constant: 0).isActive = true
        
        descriptionLabel.leftAnchor.constraint(equalTo: itemDescription.leftAnchor, constant: 0).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: itemDescription.topAnchor, constant: -8).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: itemDescription.bottomAnchor, constant: 0).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: itemDescription.centerXAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        stackView.axis = .vertical
        stackView2.distribution = .fillEqually
        stackView.addArrangedSubview(womanImage)
        stackView.addArrangedSubview(stackView2)
        stackView.distribution = .fillEqually
        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
    }
    
  /*  override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 20)!]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }*/
    
   /* override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
    }*/
    
    
}*/
