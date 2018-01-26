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
        scrollView.addSubview(postImage)
        scrollView.addSubview(cityWord)
        scrollView.addSubview(cityLabel)
        scrollView.addSubview(locationWord)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(descriptiontextField)
        scrollView.addSubview(tableView)
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.allowsSelection = false
        tableView.register(CommentsCell.self, forCellReuseIdentifier: cellId)
        getComment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getComment()
    }
    
    var tableView = UITableView()
    
    func setupView(){
        
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.backgroundColor = .white
        
        
        
       // scrollView.addSubview(boxView)
        var yPosition: CGFloat = 0
        postImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 16 * 9)
        postImage.loadImageUsingCacheWithUrlString(imageUrl)
        
        yPosition += UIScreen.main.bounds.height / 16 * 9
        
        
        cityWord.frame = CGRect(x: 8, y: yPosition + 8, width: 48, height: 24)
        
        
        let cityLabelHeight = heightForView(text: cityLabel.text!, font: UIFont(name: "Avenir Next", size: 20)!, width: UIScreen.main.bounds.width - 64 - 8)
        cityLabel.frame = CGRect(x: 8 + cityWord.frame.width, y: yPosition + 6, width: UIScreen.main.bounds.width, height: cityLabelHeight)
        
        yPosition += 6 + cityLabelHeight
        
        
        locationWord.frame = CGRect(x: 8, y: yPosition + 8, width: 64, height: 24)
        
        
        let locationLabelHeight = heightForView(text: locationLabel.text!, font: UIFont(name: "Avenir Next", size: 20)!, width: UIScreen.main.bounds.width - locationWord.frame.width - 8)
        locationLabel.frame = CGRect(x: locationWord.frame.width + 8, y: yPosition + 6, width: UIScreen.main.bounds.width - locationWord.frame.width - 8, height: locationLabelHeight)
        
        yPosition += 6 + locationLabelHeight
        
        
        let descriptionTextFieldHeight = heightForView(text: descriptiontextField.text!, font: UIFont(name: "Avenir Next", size: 20)!, width: UIScreen.main.bounds.width - 8)
        descriptiontextField.frame = CGRect(x: 4, y: yPosition + 8 + 16, width: UIScreen.main.bounds.width - 8, height: descriptionTextFieldHeight)
        
        yPosition += 8 + descriptionTextFieldHeight + 16
        
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.layoutIfNeeded()
        tableView.frame = CGRect(x: 0, y: yPosition + 8, width: UIScreen.main.bounds.width, height: tableView.contentSize.height)
        
        
        yPosition += tableView.contentSize.height
        
        print(yPosition,"<------", tableView.contentSize.height)
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: yPosition + 10)
        
        scrollView.layoutIfNeeded()
        
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
        
        view.addSubview(circle)
        circle.addSubview(pliusas)
        
        circle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        circle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 60).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        pliusas.translatesAutoresizingMaskIntoConstraints = false
        pliusas.widthAnchor.constraint(equalTo: circle.widthAnchor, multiplier: 0.5).isActive = true
        pliusas.heightAnchor.constraint(equalTo: circle.heightAnchor, multiplier: 0.5).isActive = true
        pliusas.centerXAnchor.constraint(equalTo: circle.centerXAnchor).isActive = true
        pliusas.centerYAnchor.constraint(equalTo: circle.centerYAnchor).isActive = true
    }
    
    let boxView: UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 5
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
       scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let cityWord: UILabel = {
        let label = UILabel()
        label.text = "City: "
        label.textAlignment = .left
        label.sizeToFit()
        //label.backgroundColor = .red
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()
    
    let commentsWord: UILabel = {
       let label = UILabel()
        label.text = "Comments:"
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
       // label.sizeToFit()
        //label.backgroundColor = .blue
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir Next", size: 20)
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
                print("not in followed")
                
                self.isItFollowed = false
                self.followBool = true
                
            }
            else {
                print("followed")
                self.isItFollowed = true
                self.followBool = false
                
            }
        })
    }
    
    
    var followBool: Bool = false{
        didSet {
            if followBool {
                
                followButton.setTitle("Follow", for: .normal)
                let uid = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("users").child(uid!).child("followed").child(postName)
                
                let anotherRef = ref
                anotherRef.removeValue()
                
            }
            else {
                followButton.setTitle("Unfollow", for: .normal)
                let uid = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("allPosts").child(foundOrLost).child(postName)
                ref.observe(.value, with: { (snapshot) in
                    print(snapshot)
                    let followedRef = Database.database().reference().child("users").child(uid!).child("followed").child(postName)
                    followedRef.setValue(snapshot.value)
                    DispatchQueue.main.async {
                        let timeStamp = Int(NSDate().timeIntervalSince1970)
                        followedRef.child("timeStamp").setValue(timeStamp * -1)
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
        let vc = AddCommentController()
        vc.email.text = "to: \((posterUid.text)!)"
        vc.postName = postName
        
        
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
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for snap in snapshots {
                if let comment = snap.childSnapshot(forPath: "comment").value as? String {
                    self.comments.append(comment)
                    let cell = CommentsCell()
                    cell.cellWidths.append(comment.widthOfString(usingFont: UIFont(name: "Avenir Next", size: 16)!))
                    // print(comment.widthOfString(usingFont: UIFont(name: "Avenir Next", size: 16)!),"<--------", UIScreen.main.bounds.width * 0.7)
                    //print(print(comment.heightOfString(usingFont: UIFont(name: "Avenir Next", size: 16)!),"<--------"))
                    print(self.comments)
                }
                
                if let email = snap.childSnapshot(forPath: "name").value as? String {
                    self.fromEmail.append(email)
                }
                
                DispatchQueue.main.async {
                    self.setupView()
                    self.tableView.reloadData()
                    
                }
            }
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
