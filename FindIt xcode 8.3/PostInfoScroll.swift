//
//  PostInfoScroll.swift
//  FindIt xcode 8.3
//
//  Created by rytis razmus on 25/01/2018.
//  Copyright © 2018 Rytis. All rights reserved.
//

import UIKit
import Firebase

class PostInfoScroll: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
       // scrollView.addSubview(postImage)
//        scrollView.addSubview(cityWord)
//        scrollView.addSubview(cityLabel)
//        scrollView.addSubview(locationWord)
//        scrollView.addSubview(locationLabel)
//        scrollView.addSubview(descriptiontextField)
//        scrollView.addSubview(tableView)
        
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.allowsSelection = false
        tableView.register(CommentsCell.self, forCellReuseIdentifier: cellId)
        getComment()
        checkIfPostIsInFollowed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getComment()
    }
    
    let containerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let streetCityDateView: UIView = {
       let view = UIView()
        
        view.backgroundColor = myColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let descriptionBackgroundView: UIView = {
        let view = UIView()
        
        view.backgroundColor = myColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let posterName: UILabel = {
        let view = UILabel()
        
        view.text = posterUid.text
        view.textColor = myColor
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let envelopeImage: UIButton = {
        let iv = UIButton()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        iv.setImage(UIImage(named: "envelopeAndroid")?.withRenderingMode(.alwaysTemplate), for: .normal)
        iv.addTarget(self, action: #selector(toPostComment), for: .touchUpInside)
        
        return iv
    }()
    
    let chatImage: UIButton = {
        let iv = UIButton()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        iv.setImage( UIImage(named: "commentsAndroid")?.withRenderingMode(.alwaysTemplate), for: .normal)
        iv.addTarget(self, action: #selector(toChatController), for: .touchUpInside)
        
        return iv
    }()
    
    let followImage: UIButton = {
        let iv = UIButton()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        iv.setImage(UIImage(named: "follow_button"), for: .normal)
        iv.addTarget(self, action: #selector(followPost), for: .touchUpInside)
        
        return iv
    }()
   
    
    
    let editImage: UIButton = {
        let iv = UIButton()
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        iv.setImage(UIImage(named: "edit_image")?.withRenderingMode(.alwaysTemplate), for: .normal)
        iv.addTarget(self, action: #selector(toEditPost), for: .touchUpInside)
        
        return iv
    }()
    
    let commentsButton: UIButton = {
       let bt = UIButton()
        
        bt.setTitle("Comments(0)", for: .normal)
        bt.backgroundColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        bt.addTarget(self, action: #selector(toPostComment), for: UIControlEvents.touchUpInside)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.layer.cornerRadius = 5
        bt.titleLabel?.font =  UIFont(name: "Avenir Next", size: 18)
  
        return bt
    }()
    
    
    
    var tableView = UITableView()
    
    func setupView(){
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 760)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        scrollView.addSubview(containerView)
        
        
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        var containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: scrollView.contentSize.height)
        
        containerViewHeightAnchor.isActive = true
        
        containerView.addSubview(posterName)
        
        posterName.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        posterName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        posterName.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        posterName.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        containerView.addSubview(postImage)
        
        postImage.translatesAutoresizingMaskIntoConstraints = false
        
        postImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 48).isActive = true
        postImage.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        postImage.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        postImage.heightAnchor.constraint(equalTo: postImage.widthAnchor).isActive = true
        
        postImage.loadImageUsingCacheWithUrlString(imageUrl)
        
        
        
        containerView.addSubview(envelopeImage)
        
        envelopeImage.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        envelopeImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        envelopeImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        envelopeImage.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8).isActive = true
        
        let currUser = Auth.auth().currentUser?.uid
        
        if toIdd != currUser {
        
        containerView.addSubview(chatImage)
        
        chatImage.leftAnchor.constraint(equalTo: envelopeImage.rightAnchor, constant: 12).isActive = true
        chatImage.widthAnchor.constraint(equalTo: envelopeImage.widthAnchor).isActive = true
        chatImage.heightAnchor.constraint(equalTo: envelopeImage.heightAnchor).isActive = true
        chatImage.topAnchor.constraint(equalTo: envelopeImage.topAnchor, constant: 0).isActive = true
        
        containerView.addSubview(followImage)
        
        followImage.leftAnchor.constraint(equalTo: chatImage.rightAnchor, constant: 12).isActive = true
        followImage.widthAnchor.constraint(equalTo: chatImage.widthAnchor).isActive = true
        followImage.heightAnchor.constraint(equalTo: chatImage.heightAnchor).isActive = true
        followImage.topAnchor.constraint(equalTo: chatImage.topAnchor, constant: 0).isActive = true
        } else {
            containerView.addSubview(editImage)
            
            editImage.leftAnchor.constraint(equalTo: envelopeImage.rightAnchor, constant: 12).isActive = true
            editImage.widthAnchor.constraint(equalToConstant: 29).isActive = true
            editImage.heightAnchor.constraint(equalToConstant: 29).isActive = true
            editImage.topAnchor.constraint(equalTo: envelopeImage.topAnchor, constant: 0).isActive = true
        }
        
        containerView.addSubview(streetCityDateView)
        
        streetCityDateView.translatesAutoresizingMaskIntoConstraints = false
        
        streetCityDateView.topAnchor.constraint(equalTo: envelopeImage.bottomAnchor, constant: 24).isActive = true
        streetCityDateView.leftAnchor.constraint(equalTo: envelopeImage.leftAnchor, constant: 0).isActive = true
        streetCityDateView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        streetCityDateView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        
        streetCityDateView.addSubview(cityWord)
        
        cityWord.translatesAutoresizingMaskIntoConstraints = false
        
        cityWord.text = "City: " + cityLabel.text!
        //cityWord.backgroundColor = .red
        cityWord.leftAnchor.constraint(equalTo: streetCityDateView.leftAnchor, constant: 4).isActive = true
        cityWord.topAnchor.constraint(equalTo: streetCityDateView.topAnchor, constant: 4).isActive = true
        cityWord.rightAnchor.constraint(equalTo: streetCityDateView.rightAnchor, constant: 4).isActive = true
        cityWord.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        streetCityDateView.addSubview(locationWord)
        
        locationWord.translatesAutoresizingMaskIntoConstraints = false
        
        locationWord.text = "Street: " + locationLabel.text!
        
        locationWord.leftAnchor.constraint(equalTo: cityWord.leftAnchor, constant: 0).isActive = true
        locationWord.topAnchor.constraint(equalTo: cityWord.bottomAnchor, constant: 4).isActive = true
        locationWord.rightAnchor.constraint(equalTo: streetCityDateView.rightAnchor, constant: 4).isActive = true
        locationWord.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        streetCityDateView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: cityWord.leftAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: locationWord.bottomAnchor, constant: 4).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        containerView.addSubview(descriptionBackgroundView)
        
        containerView.addSubview(descriptiontextField)
        
        descriptiontextField.translatesAutoresizingMaskIntoConstraints = false
        
        //descriptiontextField.backgroundColor = myColor
        descriptiontextField.textColor = .white
        //descriptiontextField.layer.cornerRadius = 20
        
        descriptiontextField.widthAnchor.constraint(equalTo: streetCityDateView.widthAnchor, multiplier: 0.95).isActive = true
        descriptiontextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
        descriptiontextField.leftAnchor.constraint(equalTo: streetCityDateView.leftAnchor).isActive = true
        descriptiontextField.topAnchor.constraint(equalTo: streetCityDateView.bottomAnchor, constant: 16).isActive = true //148 , 104
        
        
        
        descriptionBackgroundView.widthAnchor.constraint(equalTo: streetCityDateView.widthAnchor).isActive = true
        descriptionBackgroundView.heightAnchor.constraint(equalTo: descriptiontextField.heightAnchor, constant: 8).isActive = true
        descriptionBackgroundView.centerXAnchor.constraint(equalTo: streetCityDateView.centerXAnchor).isActive = true
        descriptionBackgroundView.centerYAnchor.constraint(equalTo: descriptiontextField.centerYAnchor).isActive = true
        
        
        
        containerView.addSubview(commentsButton)
        
        commentsButton.topAnchor.constraint(equalTo: descriptionBackgroundView.bottomAnchor, constant: 8).isActive = true
        commentsButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        commentsButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        commentsButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        scrollView.resizeScrollViewContentSize()
        
        scrollView.layoutIfNeeded()
        view.layoutIfNeeded()
        
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 144 + descriptionBackgroundView.frame.height + postImage.frame.height + posterName.frame.height + streetCityDateView.frame.height + 8)
       
       // scrollView.resizeScrollViewContentSize()
       
       
        
        containerViewHeightAnchor.isActive = false
        
        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: scrollView.contentSize.height)
        
        containerViewHeightAnchor.isActive = true
        
        
       
    
        
       // scrollView.addSubview(boxView)
        
        
//        //nuo cia
//        var yPosition: CGFloat = 0
//        postImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 16 * 9)
//        postImage.loadImageUsingCacheWithUrlString(imageUrl)
//        
//        yPosition += UIScreen.main.bounds.height / 16 * 9
//        
//        
//        cityWord.frame = CGRect(x: 8, y: yPosition + 8, width: 48, height: 24)
//        
//        
//        let cityLabelHeight = heightForView(text: cityLabel.text!, font: UIFont(name: "Avenir Next", size: 20)!, width: UIScreen.main.bounds.width - 64 - 8)
//        cityLabel.frame = CGRect(x: 8 + cityWord.frame.width, y: yPosition + 6, width: UIScreen.main.bounds.width, height: cityLabelHeight)
//        
//        yPosition += 6 + cityLabelHeight
//        
//        
//        locationWord.frame = CGRect(x: 8, y: yPosition + 8, width: 64, height: 24)
//        
//        
//        let locationLabelHeight = heightForView(text: locationLabel.text!, font: UIFont(name: "Avenir Next", size: 20)!, width: UIScreen.main.bounds.width - locationWord.frame.width - 8)
//        locationLabel.frame = CGRect(x: locationWord.frame.width + 8, y: yPosition + 6, width: UIScreen.main.bounds.width - locationWord.frame.width - 8, height: locationLabelHeight)
//        
//        yPosition += 6 + locationLabelHeight
//        
//        
//        let descriptionTextFieldHeight = heightForView(text: descriptiontextField.text!, font: UIFont(name: "Avenir Next", size: 20)!, width: UIScreen.main.bounds.width - 8)
//        descriptiontextField.frame = CGRect(x: 4, y: yPosition + 8 + 16, width: UIScreen.main.bounds.width - 8, height: descriptionTextFieldHeight)
//        
//        descriptiontextField.backgroundColor = myColor
//        descriptiontextField.layer.cornerRadius = 5
//        descriptiontextField.textColor = .white
//        
//        
//        
//        yPosition += 8 + descriptionTextFieldHeight + 32
//        
//        scrollView.addSubview(commentsView)
//        commentsView.frame = CGRect(x: 0, y: yPosition, width: UIScreen.main.bounds.width, height: 30)
//        scrollView.addSubview(commentsWord)
//        commentsWord.frame = CGRect(x: view.frame.midX - 50, y: yPosition + 5, width: 100, height: 20)
//        
//        yPosition += commentsView.frame.height
//        
//        tableView.estimatedRowHeight = 44
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.layoutIfNeeded()
//        tableView.frame = CGRect(x: 0, y: yPosition + 8, width: UIScreen.main.bounds.width, height: tableView.contentSize.height)
//        
//        
//        yPosition += tableView.contentSize.height
//        
//        print(yPosition,"<------", tableView.contentSize.height)
//        
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: yPosition + 10)
//        
//        scrollView.layoutIfNeeded()
//        view.layoutIfNeeded()
//        
//        //iki cia
        
//        postImage.frame = CGRect(x: UIScreen.main.bounds.width / 2 - (UIScreen.main.bounds.width ) / 2, y: 8, width: UIScreen.main.bounds.width, height: 300)
//        postImage.loadImageUsingCacheWithUrlString(imageUrl)
//        scrollView.addSubview(descriptiontextField)
//        descriptiontextField.frame = CGRect(x: 16, y: 316, width: UIScreen.main.bounds.width - 32, height: heightForView(text: descriptiontextField.text!, font: UIFont(name: "Avenir Next", size: 21)!, width: UIScreen.main.bounds.width))
//        //        scrollView.addSubview(commentsWord)
//        //        commentsWord.frame = CGRect(x: 16, y: 350, width: 100, height: 32)
//        
//        let descriptionTextFieldHeight = heightForView(text: descriptiontextField.text!, font: UIFont(name: "Avenir Next", size: 21)!, width: UIScreen.main.bounds.width)
//        
//        scrollView.addSubview(cityWord)
//        
//        let yPosition  = 328 + descriptiontextField.frame.height
//        
//        cityWord.frame = CGRect(x: 16, y: yPosition, width: 48, height: 32)
//        
//        scrollView.addSubview(cityLabel)
//        cityLabel.frame = CGRect(x: 63, y: yPosition + 2, width: UIScreen.main.bounds.width - 89, height: heightForView(text: cityLabel.text!, font: UIFont(name: "Avenir Next", size: 21)!, width: UIScreen.main.bounds.width - 89))
//        
//        let cityLabelHeight = heightForView(text: cityLabel.text!, font: UIFont(name: "Avenir Next", size: 21)!, width: UIScreen.main.bounds.width - 89)
//        
//        scrollView.addSubview(locationWord)
//        locationWord.frame = CGRect(x: 16, y: yPosition + cityLabelHeight + 8, width: 64, height: 32)
//        
//        scrollView.addSubview(locationLabel)
//        
//        locationLabel.frame = CGRect(x: 16 + 64, y: yPosition + cityLabelHeight + 8 + 2, width: UIScreen.main.bounds.width - 88 - 8, height: heightForView(text: locationLabel.text!, font: UIFont(name: "Avenir Next", size: 20)!, width: UIScreen.main.bounds.width - 88 - 8))
//        
//        let locationLabelHeight = heightForView(text: locationLabel.text!, font: UIFont(name: "Avenir Next", size: 20)!, width: UIScreen.main.bounds.width - 88 - 8)
//        
//        scrollView.addSubview(tableView)
//        tableView.frame = CGRect(x: 0, y: 8 + locationLabelHeight +  yPosition + 30 + cityLabelHeight + 8 + 2, width: UIScreen.main.bounds.width, height: 200)
//        
//        boxView.frame = CGRect(x: 8, y: 312, width: UIScreen.main.bounds.width - 16, height: 12 + descriptionTextFieldHeight)
//        
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 8 + locationLabelHeight +  yPosition + descriptionTextFieldHeight + cityLabelHeight + 8 + 2 + 200)
        
//        view.addSubview(circle)
//        circle.addSubview(pliusas)
//
//        circle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
//        circle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
//        circle.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        circle.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        
//        pliusas.translatesAutoresizingMaskIntoConstraints = false
//        pliusas.widthAnchor.constraint(equalTo: circle.widthAnchor, multiplier: 0.5).isActive = true
//        pliusas.heightAnchor.constraint(equalTo: circle.heightAnchor, multiplier: 0.5).isActive = true
//        pliusas.centerXAnchor.constraint(equalTo: circle.centerXAnchor).isActive = true
//        pliusas.centerYAnchor.constraint(equalTo: circle.centerYAnchor).isActive = true
    }
    
    let commentsView: UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.layer.borderWidth = 0.5
        //view.layer.cornerRadius = 5
        view.backgroundColor = .yellow
        return view
    }()
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
       scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let cityWord: UILabel = {
        let label = UILabel()
        label.text = "City: "
        label.textAlignment = .left
        label.sizeToFit()
        label.textColor = .white
        //label.backgroundColor = .red
        
        label.font = UIFont(name: "Avenir Next", size: 16)
        
        return label
    }()
    
    let commentsWord: UILabel = {
       let label = UILabel()
        label.text = "Comments"
        label.font = UIFont(name: "Avenir Next", size: 16)
        return label
    }()
    
    let postImage: UIImageView = {
       let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let locationWord: UILabel = {
        let label = UILabel()
        label.text = "Street: "
        label.textAlignment = .left
        label.textColor = .white
       // label.sizeToFit()
        //label.backgroundColor = .blue
        
        label.font = UIFont(name: "Avenir Next", size: 16)
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "date: 2018-03-03"
        label.textAlignment = .left
        label.textColor = .white
        // label.sizeToFit()
        //label.backgroundColor = .blue
        
        label.font = UIFont(name: "Avenir Next", size: 16)
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(followPost), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)
        button.layer.cornerRadius = 6
        button.backgroundColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)//myColor
        button.alpha = 0
        return button
    }()
    
    @objc func followPost(){
        followBool = !followBool
        
        //        followButton.removeTarget(self, action: #selector(followPost), for: .touchUpInside)
        //        followButton.addTarget(self, action: #selector(unfollow), for: .touchUpInside)
        //        let uid = Auth.auth().currentUser?.uid
        //        let ref = Database.database().reference().child("allPosts").child(foundOrLost).child(postName)
        //        ref.observe(.value, with: { (snapshot) in
        //            print(snapshot)
        //            let followedRef = Database.database().reference().child("users").child(uid!).child("followed").child(postName)
        //            followedRef.setValue(snapshot.value)
        //        })
    }
    var isItFollowed = false
    
    
    func checkIfPostIsInFollowed(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!).child("followed").child(postName)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() == false {
                
                let timeStamp = Int(NSDate().timeIntervalSince1970) * -1
                
                self.isItFollowed = false
                self.followBool = true
                
            }
            else {
                
                self.isItFollowed = true
                self.followBool = false
                
            }
        })
    }
    
    
    var followBool: Bool = false{
        didSet {
            if followBool {
                
                //followButton.setTitle("Follow", for: .normal)
                followImage.setImage(UIImage(named:"follow_button"), for: .normal)
                let uid = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("users").child(uid!).child("followed").child(postName)
                let followersRef = Database.database().reference().child("followers").child(postName).child(uid!)
                let anotherRef = ref
                let followersRemoveRef = followersRef
                followersRemoveRef.removeValue()
                anotherRef.removeValue()
                
            }
            else {
                //followButton.setTitle("Unfollow", for: .normal)
                followImage.setImage(UIImage(named:"unfollow_button"), for: .normal)
                let uid = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("allPosts").child(foundOrLost).child(postName)
                ref.observe(.value, with: { (snapshot) in
                    
                    let followedRef = Database.database().reference().child("users").child(uid!).child("followed").child(postName)
                    followedRef.setValue(snapshot.value)
                    followedRef.child("foundOrLost").setValue(foundOrLost)
                    //followedRef.child(snapshot.key)
                    let timeStamp = Int(NSDate().timeIntervalSince1970)
                    followedRef.child("timeStamp").setValue(timeStamp * -1)
                    let followersRef = Database.database().reference().child("followers").child(postName).child(uid!)
                    DispatchQueue.main.async {
                        followersRef.setValue(1)
                    }
                })
            }
        }
    }
    
    var followUnfollow = UIButton()
    
    let unfollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Unfollow", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(unfollow), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)
        button.layer.cornerRadius = 6
        button.alpha = 0
        
        button.backgroundColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)//myColor//UIColor(patternImage: patternImage!)
        return button
    }()
    
    @objc func unfollow(){
        
        //        unfollowButton.removeTarget(self, action: #selector(unfollow), for: .touchUpInside)
        //        unfollowButton.addTarget(self, action: #selector(followPost), for: .touchUpInside)
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!).child("followed").child(postName)
        let anotherRef = ref
        anotherRef.removeValue()
    }
    
    let pliusas = UIImageView(image: (UIImage(named: "pliusas2")))//((UIImage(named: "Pliusas")))
    
    let circle: UIButton = {
        let circle = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.cornerRadius = 30
        circle.backgroundColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)//UIColor(red: 255/255, green: 209/255, blue: 151/255, alpha: 1)//myColor//UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)//myColor//UIColor(patternImage: patternImage!)
        circle.addTarget(self, action: #selector(circleAction), for: .touchUpInside)
        
        circle.alpha = 0.5
        return circle
    }()
    
    @objc func circleAction(){
        circleBool = !circleBool
    }
    
    let toMessagesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Write a private message", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toChatController), for: .touchUpInside)
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)
        button.alpha = 0
        
        button.backgroundColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)//myColor//UIColor(patternImage: patternImage!)
        
        return button
    }()

    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit post", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toEditPost), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)
        button.layer.cornerRadius = 6
        button.alpha = 0
        
        button.backgroundColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)//myColor//UIColor(patternImage: patternImage!)
        return button
    }()
    
    @objc func toEditPost(){
        
        let vc = AddItemController()
        
        //let cellTwo = tableView.dequeueReusableCell(withIdentifier: cellIdTwo, for: indexPath) as! PostInfoStuff
        vc.itemDescription.text = descriptiontextField.text//cellTwo.descriptiontextField.text
        let img = UIImageView()
        img.loadImageUsingCacheWithUrlString(imageUrl)
        let editableImage = img.image
        vc.tempButtonWithImage.setImage(editableImage, for: .normal)
        vc.imageToPost = editableImage
        vc.isUserEditing = true
        vc.editPostName = postName
        vc.cityForEdit = cityLabel.text!
        present(vc, animated: true, completion: nil)
    }

    var usserrr = String()
    // var postName = String()
    let allUsers = EveryUser()
    //  let tableView = UITableView()

    
    var postId = String()
    
    var toId = String()
    var chat = Chat(collectionViewLayout: UICollectionViewFlowLayout())
    
    @objc func toChatController(){
        //self.comments.removeAll()
        let ref = Database.database().reference().child("allPosts").child(foundOrLost).child(postName)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                if let dictionary = snapshot.value as? [String: Any] {
                    self.toId = dictionary["uid"] as! String
                    self.allUsers.toId = dictionary["uid"] as! String
                    
                    self.chat.fromID = (Auth.auth().currentUser?.uid)!
                    self.chat.toId = toIdd
                }
                DispatchQueue.main.async {
                    self.circleBool = false
                    self.navigationController?.pushViewController(self.chat, animated: true)
                }
            }
        }, withCancel: nil)
        
    }
    
    let addCommentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Write a comment", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toPostComment), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)
        button.layer.cornerRadius = 6
        button.alpha = 0
        
        button.backgroundColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)//myColor//.red//UIColor(patternImage: patternImage!)
        
        return button
        
    }()
    
    @objc func toPostComment(){
        circleBool = false
        let vc = CommentsControllerViewController()
        vc.email = "to: \((posterUid.text)!)"
        //vc.postName = postName
        
        
        show(vc, sender: self)
        
    }
    

    
    var circleBool:Bool = false{
        didSet {
            
            if circleBool == true{
                view.addSubview(addCommentButton)
                
                
                UIView.animate(withDuration: 0.34, animations: {
                    self.circle.alpha = 1
                    self.followButton.alpha = 1
                    self.toMessagesButton.alpha = 1
                    self.addCommentButton.alpha = 1
                    self.editButton.alpha = 1
                }, completion: nil)
                
                addCommentButton.bottomAnchor.constraint(equalTo: circle.topAnchor, constant: -16).isActive = true
                addCommentButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
                addCommentButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
                addCommentButton.widthAnchor.constraint(equalToConstant: 134).isActive = true
                
                if toIdd != Auth.auth().currentUser?.uid{
                    view.addSubview(toMessagesButton)
                    view.addSubview(followButton)
                    
                    toMessagesButton.bottomAnchor.constraint(equalTo: addCommentButton.topAnchor, constant: -8).isActive = true
                    toMessagesButton.rightAnchor.constraint(equalTo: addCommentButton.rightAnchor, constant: 0).isActive = true
                    toMessagesButton.heightAnchor.constraint(equalTo: addCommentButton.heightAnchor, constant: 0).isActive = true
                    toMessagesButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
                    
                    followButton.bottomAnchor.constraint(equalTo: toMessagesButton.topAnchor, constant: -8).isActive = true
                    followButton.rightAnchor.constraint(equalTo: toMessagesButton.rightAnchor).isActive = true
                    followButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
                    followButton.heightAnchor.constraint(equalTo: toMessagesButton.heightAnchor).isActive = true
                }
                else if toIdd == Auth.auth().currentUser?.uid {
                    
                    view.addSubview(editButton)
                    editButton.bottomAnchor.constraint(equalTo: addCommentButton.topAnchor, constant: -8).isActive = true
                    editButton.rightAnchor.constraint(equalTo: addCommentButton.rightAnchor, constant: 0).isActive = true
                    editButton.heightAnchor.constraint(equalTo: addCommentButton.heightAnchor, constant: 0).isActive = true
                    editButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
                    
                }
                
                
                
            }   else {
                UIView.animate(withDuration: 0.34, animations: {
                    self.circle.alpha = 0.5
                    self.toMessagesButton.alpha = 0
                    self.addCommentButton.alpha = 0
                    self.followButton.alpha = 0
                    self.editButton.alpha = 0
                }, completion: { (true) in
                    self.followButton.removeFromSuperview()
                    self.toMessagesButton.removeFromSuperview()
                    self.addCommentButton.removeFromSuperview()
                    self.editButton.removeFromSuperview()
                    self.addCommentButton.removeFromSuperview()
                    
                })
            }
        }
    }
    var comments = [String]()
    var fromEmail = [String]()
    
    func getComment(){
        
        let ref = Database.database().reference().child("allPosts").child("comments").child(postName)
        
        ref.queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: { (snapshot) in
            self.comments.removeAll()
            self.fromEmail.removeAll()
            
            self.commentsButton.setTitle("Comments(\(snapshot.childrenCount))", for: .normal)
            
//            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
//            for snap in snapshots {
//                if let comment = snap.childSnapshot(forPath: "comment").value as? String {
//                    self.comments.append(comment)
//                    let cell = CommentsCell()
//                    cell.cellWidths.append(comment.widthOfString(usingFont: UIFont(name: "Avenir Next", size: 16)!))
//                    // print(comment.widthOfString(usingFont: UIFont(name: "Avenir Next", size: 16)!),"<--------", UIScreen.main.bounds.width * 0.7)
//                    //print(print(comment.heightOfString(usingFont: UIFont(name: "Avenir Next", size: 16)!),"<--------"))
//                    print(self.comments)
//                }
//                
//                if let email = snap.childSnapshot(forPath: "name").value as? String {
//                    self.fromEmail.append(email)
//                }
//                
//                DispatchQueue.main.async {
//                    self.setupView()
//                    self.tableView.reloadData()
//                    
//                }
//            }
        }, withCancel: nil)
        self.tableView.reloadData()
    }
    let cellId = "cellBlah"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentsCell
        
        cell.awakeFromNib()

       // var sender = fromEmail[indexPath.row]
        cell.emailLabel.text = fromEmail[indexPath.row]
        cell.message.text = "\(comments[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
}
extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            
            contentRect = contentRect.union(view.frame)
            
        }
        
        self.contentSize = contentRect.size
        
    }
    
}

