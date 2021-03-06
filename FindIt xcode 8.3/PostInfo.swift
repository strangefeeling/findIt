
//
//  PostInfo.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 18/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase
import CoreGraphics

var posterEmail = String()

var firstCellHeight: CGFloat = 0

class PostInfo: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var isCommentByPoster: Bool = false
    
    var lat: String?
    
    var lon: String?
    
    var locationName: String?
    
    var bandymas = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = myColor
        
        tableView.dataSource = self
        tableView.delegate = self
        setupView()

        tableView.register(CommentsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(PostInfoStuff.self, forCellReuseIdentifier: cellIdTwo)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        checkIfPostIsInFollowed()
        
        if shouldIDismiss{
            popRoot()
            shouldIDismiss = false
        }
        descriptiontextField.sizeToFit()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 5
        getComment()
        tableView.rowHeight = UITableViewAutomaticDimension
        firstCellHeight = UIScreen.main.bounds.height / 2.5 + 7 * (UIScreen.main.bounds.height / 33.35 + 8)  + descriptiontextField.frame.height
        if toIdd == Auth.auth().currentUser?.uid{
            
           // navigationController?.navigationBar.tintColor = .red
            //navigationController?.navigationBar.set 
           
        }
    }
    
    

    var comments = [String]()
    
    let cellId = "cell"
    
    var tableView = UITableView()
    
    
    var usserrr = String()
    // var postName = String()
    let allUsers = EveryUser()
    //  let tableView = UITableView()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        //scrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth | UIViewAutoresizing.flexibleHeight
        return scrollView
    }()
    
    var postId = String()
    
    var toId = String()
    var chat = Chat(collectionViewLayout: UICollectionViewFlowLayout())
    
    
    let cityWord: UILabel = {
        let label = UILabel()
        label.text = "City:809890238902 "
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
    
    var fromEmail = [String]()
    
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
                
                
                self.isItFollowed = false
                self.followBool = true
                
            }
            else {
                
                self.isItFollowed = true
                self.followBool = false
                
            }
        })
    }
    
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
    //_________________________________________________________//_________________________________________________________
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

    func popRoot(){
        
        navigationController?.popViewController(animated: true)
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
                    
                    let followedRef = Database.database().reference().child("users").child(uid!).child("followed").child(postName)
                    followedRef.setValue(snapshot.value)
                    DispatchQueue.main.async {
                        let timeStamp = Int(NSDate().timeIntervalSince1970)
                        //followedRef.child("timeStamp").setValue(timeStamp * -1)
                    }
                })
            }
        }
    }
    
    var followUnfollow = UIButton()
    
    var circleBool:Bool = false{
        didSet {
            
            if circleBool == true{
                //navigationController?.popViewController(animated: true)
                
                
                
//                if isItFollowed {
//                    followUnfollow = unfollowButton
//                    followUnfollow.setTitle("unfollow", for: .normal)
//                } else {
//                    followUnfollow = followButton
//                    followUnfollow.setTitle("follow", for: .normal)
//                }
                
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
    
    
    //-------------------------------------------------------------------------------------------------------
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
                    
                }
                
                if let email = snap.childSnapshot(forPath: "name").value as? String {
                    self.fromEmail.append(email)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }, withCancel: nil)
        self.tableView.reloadData()
    }
    
    
    @objc func circleAction(){
        circleBool = !circleBool
    }
    
    @objc func toPostComment(){
        circleBool = false
        let vc = AddCommentController()
        vc.email.text = "to: \((posterUid.text)!)"
        vc.postName = postName
        
        
        show(vc, sender: self)
        
    }
    
    /*  func drawLine(){
     // let circlePath = UIBezierPath(arcCenter: CGPoint(x: 300, y: 300), radius: CGFloat(20), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
     /*let shapeLayer = CAShapeLayer()
     shapeLayer.path = circlePath.cgPath
     shapeLayer.fillColor = myColor.cgColor
     shapeLayer.lineWidth = 3
     
     circle.layer.addSublayer(shapeLayer)*/
     
     let aPath = UIBezierPath()
     aPath.move(to: CGPoint(x: 40, y: 200))
     aPath.addLine(to: CGPoint(x: 400, y: 500))
     aPath.lineWidth = 10
     aPath.close()
     aPath.fill()
     let aLayer = CAShapeLayer()
     aLayer.path = aPath.cgPath
     aLayer.fillColor = UIColor.white.cgColor
     circle.layer.addSublayer(aLayer)
     
     }*/
    
    
    
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
    
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    
    func setupView(){
        view.addSubview(tableView)
        
        // scrollView.addSubview(image)
        // scrollView.addSubview(cityWord)
        // scrollView.addSubview(locationWord)
        // scrollView.addSubview(cityLabel)
        // scrollView.addSubview(locationLabel)
        // scrollView.addSubview(dateLabel)
        // scrollView.addSubview(descriptiontextField)
        
        view.addSubview(circle)
        circle.addSubview(pliusas)
        //scrollView.addSubview(writeMessageButton)
        
        pliusas.tintColor = .blue
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        
        circle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        circle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 60).isActive = true
        circle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        pliusas.translatesAutoresizingMaskIntoConstraints = false
        pliusas.widthAnchor.constraint(equalTo: circle.widthAnchor, multiplier: 0.5).isActive = true
        pliusas.heightAnchor.constraint(equalTo: circle.heightAnchor, multiplier: 0.5).isActive = true
        pliusas.centerXAnchor.constraint(equalTo: circle.centerXAnchor).isActive = true
        pliusas.centerYAnchor.constraint(equalTo: circle.centerYAnchor).isActive = true
        
        
        
        /*image.translatesAutoresizingMaskIntoConstraints = false
         image.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8).isActive = true
         image.topAnchor.constraint(equalTo: posterUid.bottomAnchor, constant: 0).isActive = true
         image.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
         image.heightAnchor.constraint(equalToConstant: 300).isActive = true
         
         
         descriptiontextField.translatesAutoresizingMaskIntoConstraints = false
         descriptiontextField.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16).isActive = true
         descriptiontextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
         descriptiontextField.rightAnchor.constraint(equalTo: image.rightAnchor, constant: -16).isActive = true
         
         
         cityWord.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8).isActive = true
         cityWord.topAnchor.constraint(equalTo: descriptiontextField.bottomAnchor, constant: 8).isActive = true
         cityWord.heightAnchor.constraint(equalToConstant: 20).isActive = true
         
         
         cityLabel.leftAnchor.constraint(equalTo: cityWord.rightAnchor).isActive = true
         cityLabel.heightAnchor.constraint(equalTo: cityWord.heightAnchor).isActive = true
         cityLabel.topAnchor.constraint(equalTo: cityWord.topAnchor).isActive = true
         
         locationWord.leftAnchor.constraint(equalTo: cityWord.leftAnchor).isActive = true
         locationWord.topAnchor.constraint(equalTo: cityWord.bottomAnchor, constant: 4).isActive = true
         locationWord.heightAnchor.constraint(equalTo: cityWord.heightAnchor).isActive = true
         
         locationLabel.leftAnchor.constraint(equalTo: locationWord.rightAnchor).isActive = true
         locationLabel.topAnchor.constraint(equalTo: locationWord.topAnchor).isActive = true
         locationLabel.heightAnchor.constraint(equalTo: locationWord.heightAnchor).isActive = true
         
         viewCommentsButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4).isActive = true
         viewCommentsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
         viewCommentsButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
         //viewCommentsButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
         
         dateLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
         dateLabel.topAnchor.constraint(equalTo: viewCommentsButton.bottomAnchor, constant: 8).isActive = true
         
         */
        
        
        
        // tableViewHeightConstraint.constant = tableView.contentSize.height
        
    }
    
    func setupTableView(){
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            
            return UIScreen.main.bounds.height / 2.5 + 8 * (UIScreen.main.bounds.height / 33.35 + 8) + (descriptiontextField.text?.height(withConstrainedWidth: UIScreen.main.bounds.width, font: UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)!))!// + firstCellHeight//descriptiontextField.frame.height//descriptiontextField.text?.height(withConstrainedWidth: UIScreen.main.bounds.width, font: UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)!))//descriptiontextField.frame.height + 420 + 30 + 40
            
        } else {
            
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if comments.isEmpty {
            return 1
        }
        
        return comments.count + 1
    }
    
    let cellIdTwo = "cellIdTwo"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cellTwo = tableView.dequeueReusableCell(withIdentifier: cellIdTwo, for: indexPath) as! PostInfoStuff
            cellTwo.awakeFromNib()
            
            cellTwo.imagee.loadImageUsingCacheWithUrlString(imageUrl)
            cellTwo.imagee.contentMode = .scaleAspectFit
            cellTwo.selectionStyle = UITableViewCellSelectionStyle.none
            cellTwo.dateLabel.text = dateLabel.text
            cellTwo.dateLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
            cellTwo.locationLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
            cellTwo.cityLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
            cellTwo.descriptiontextField.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
            
            cellTwo.posterUid.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
            cellTwo.commentsLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
            cellTwo.locationLabel.text = locationLabel.text
            cellTwo.cityLabel.text = cityLabel.text
            cellTwo.descriptiontextField.text = descriptiontextField.text
            cellTwo.posterUid.text = posterUid.text
            
            return cellTwo
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentsCell
            cell.awakeFromNib()
           // cell.backgroundColor = myColor
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            tableView.isUserInteractionEnabled = true
            cell.message.sizeToFit()
            cell.message.numberOfLines = 0
            cell.message.text = comments[indexPath.row - 1]
            cell.emailLabel.text = fromEmail[indexPath.row - 1]
           /* if fromEmail[indexPath.row - 1] == posterUid.text {
                cell.emailLabel.font = UIFont(name: "Avenir Next-bold", size: UIScreen.main.bounds.height / 33.5)
                cell.message.font = UIFont(name: "Avenir Next-bold", size: UIScreen.main.bounds.height / 33.5)
                cell.emailLabel.textColor = .black
            } else {*/
                cell.emailLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.5)
                cell.message.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.5)
            //}
            if comments.count == indexPath.row{
                cell.separatorLine.removeFromSuperview()
            }
            
            return cell
        }
    }
    
    
    
    
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
