
//
//  PostInfo.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 18/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//
/*
import UIKit
import Firebase
import CoreGraphics



class MyPostInfo: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var imageUrl = String()
    
    var isCommentByPoster: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        
        
        descriptiontextField.text = UserDefaults.standard.object(forKey: "descriptiontextField") as! String
        descriptiontextField.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20)
        descriptiontextField.sizeToFit()
        tableView.dataSource = self
        tableView.delegate = self
        setupView()
        getComment()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        
        //scrollView.frame = view.bounds
        //scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000)
        tableView.register(PostInfoCell.self, forCellReuseIdentifier: cellId)
        tableView.register(PostInfoStuff.self, forCellReuseIdentifier: cellIdTwo)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        //self.tableViewHeightConstraint?.isActive = true
        
    }
    
    var comments = [String]()
    
    let cellId = "cell"
    
    var tableView = UITableView()
    
    var posterUid: UILabel = {
        var uid = UILabel()
        uid.translatesAutoresizingMaskIntoConstraints = false
        uid.sizeToFit()
        //uid.backgroundColor = .yellow
        uid.font = UIFont(name: "Avenir Next", size: 16)
        uid.textColor = .darkGray
        
        return uid
    }()
    var usserrr = String()
    var postName = String()
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
    
    let image: UIImageView = {
        let image = UIImageView()
        // image.backgroundColor = .red
        image.contentMode = .top
        return image
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
    
    
    let descriptiontextField: UILabel = {
        let textField = UILabel()
        textField.text = "sadhbjkasfaksfnaklsvnzkcnaskfnsakjnakscnascnadskjnsdkjvndmnz,mcvn"
        textField.font = UIFont(name: "Avenir Next", size: 16)
        textField.numberOfLines = 0
        textField.sizeToFit()
        textField.textAlignment = .center
        return textField
    }()
    
    
    
    let pliusas = UIImageView(image: (UIImage(named: "pliusas2")))//((UIImage(named: "Pliusas")))
    
    let circle: UIButton = {
        let circle = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.cornerRadius = 30
        circle.backgroundColor = myColor
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
        
        button.backgroundColor = myColor
        
        return button
    }()
    
    var fromEmail = [String]()
    
    
    
    let addCommentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Write a comment", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toPostComment), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)
        button.layer.cornerRadius = 6
        button.alpha = 0
        
        button.backgroundColor = myColor
        
        return button
        
    }()
    
    var circleBool:Bool = false{
        didSet {
            if circleBool == true{
                view.addSubview(toMessagesButton)
                
                UIView.animate(withDuration: 0.34, animations: {
                    self.circle.alpha = 1
                    self.toMessagesButton.alpha = 1
                    self.addCommentButton.alpha = 1
                }, completion: nil)
                
                toMessagesButton.bottomAnchor.constraint(equalTo: circle.topAnchor, constant: -16).isActive = true
                toMessagesButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
                toMessagesButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
                toMessagesButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
                
                view.addSubview(addCommentButton)
                
                addCommentButton.bottomAnchor.constraint(equalTo: toMessagesButton.topAnchor, constant: -8).isActive = true
                addCommentButton.rightAnchor.constraint(equalTo: toMessagesButton.rightAnchor, constant: 0).isActive = true
                addCommentButton.heightAnchor.constraint(equalTo: toMessagesButton.heightAnchor, constant: 0).isActive = true
                addCommentButton.widthAnchor.constraint(equalToConstant: 134).isActive = true
                
                
            }   else {
                UIView.animate(withDuration: 0.34, animations: {
                    self.circle.alpha = 0.5
                    self.toMessagesButton.alpha = 0
                    self.addCommentButton.alpha = 0
                }, completion: { (true) in
                    self.toMessagesButton.removeFromSuperview()
                    self.addCommentButton.removeFromSuperview()
                    
                })
            }
        }
    }
    //-------------------------------------------------------------------------------------------------------
    func getComment(){
        
        let ref = Database.database().reference().child("allPosts").child(postName).child("comments")
        ref.queryOrdered(byChild: "timestamp").observe( .value, with: { (snapshot) in
            self.comments.removeAll()
            self.fromEmail.removeAll()
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for snap in snapshots {
                if let comment = snap.childSnapshot(forPath: "comment").value as? String {
                    self.comments.append(comment)
                    
                }
                
                if let email = snap.childSnapshot(forPath: "email").value as? String {
                    self.fromEmail.append(email)
                }
                
                DispatchQueue.main.async {
                    //self.tableView.removeFromSuperview()
                    //self.tableView.heightAnchor.constraint(equalToConstant: CGFloat(48 * self.comments.count)).isActive = true
                    
                    // self.tableViewHeightConstraint?.constant = CGFloat(self.comments.count * 48)
                    //self.setupTableView()
                    //self.tableViewHeightConstraint = self.tableView.heightAnchor.constraint(equalToConstant: CGFloat(48 * self.comments.count));
                    //self.tableViewHeightConstraint?.isActive = true
                    
                    //   self.tableView.layoutIfNeeded()
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
        self.comments.removeAll()
        let ref = Database.database().reference().child("allPosts").child(postName)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                self.toId = dictionary["uid"] as! String
                self.allUsers.toId = dictionary["uid"] as! String
                
                self.chat.fromID = (Auth.auth().currentUser?.uid)!
                self.chat.toId = self.toId
            }
            DispatchQueue.main.async {
                self.circleBool = false
                self.navigationController?.pushViewController(self.chat, animated: true)
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
            
            return descriptiontextField.frame.height + 420 + 30 + 40
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
            cellTwo.locationLabel.text = locationLabel.text
            cellTwo.cityLabel.text = cityLabel.text
            cellTwo.descriptiontextField.text = descriptiontextField.text
            cellTwo.posterUid.text = posterUid.text
            
            return cellTwo
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostInfoCell
            cell.awakeFromNib()
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.message.sizeToFit()
            cell.message.numberOfLines = 0
            cell.message.text = comments[indexPath.row - 1]
            cell.emailLabel.text = fromEmail[indexPath.row - 1]
            if fromEmail[indexPath.row - 1] == posterUid.text {
                cell.emailLabel.font = UIFont(name: "Avenir Next-bold", size: 16)
                cell.emailLabel.textColor = .black
            } else {
                cell.emailLabel.font = UIFont(name: "Avenir Next", size: 16)
            }
            if comments.count == indexPath.row{
                cell.separatorLine.removeFromSuperview()
            }
            
            return cell
        }
    }
    
    
    
    
}
*/
