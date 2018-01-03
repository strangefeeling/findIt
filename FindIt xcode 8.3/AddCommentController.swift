//
//  AddCommentController.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 17/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

class AddCommentController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sendComment))
        setConstraints()
        
        view.backgroundColor = .white
    }
  
    let currentUser = Userr()
    
    let email: UILabel = {
       let email = UILabel()
        email.text = "email@gmail.com"
        email.translatesAutoresizingMaskIntoConstraints = false
        email.sizeToFit()
        email.textColor = .darkGray
        email.numberOfLines = 0
        email.font = UIFont(name: "Avenir Next", size: 16)
        
        return email
    }()
    
    let separatorLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lightGray
        return line
    }()
    
    let commentTextView: UITextView = {
        let comment = UITextView()
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.font = UIFont(name: "Avenir Next", size: 16)
        //comment.placeholder = "Comment..."
       
        return comment
    }()
    
    var postName = String()
  
    
    func setConstraints(){
        view.addSubview(commentTextView)
        view.addSubview(email)
        view.addSubview(separatorLine)
        
        email.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        email.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        email.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        separatorLine.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 4).isActive = true
        separatorLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        separatorLine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        commentTextView.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 0).isActive = true
        commentTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        commentTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        commentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func sendComment(){
       // let postInfo = PostInfo()
        let user = Auth.auth().currentUser?.uid
        let commentName = NSUUID().uuidString
        let email = UserDefaults.standard.object(forKey: "email") as! String
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let dict = ["timestamp": timeStamp,"comment": commentTextView.text,"uid": user, "email": email] as [String : Any]
        let ref = Database.database().reference().child("allPosts").child("comments").child(postName).child(commentName)//.child(commentName).child(user!)
        let anotherRef = Database.database().reference().child("users").child(user!).child("followed").child(postName)
        anotherRef.setValue(dict)
        commentTextView.text = ""
       // postInfo.tableView.frame.origin.y += 48

        
        ref.setValue(dict)
    }
    
}
