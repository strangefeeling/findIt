//
//  MessagesController.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 26/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    var selectedUserId = [String]()
    var messagesCount = 0
    var fromName = [String]()
    var messages = [String]()
    var toName = [String]()
    var toUser = String()
    var fromUser = String()
    var toEmail = [String]()
    var fromEmail = [String]()
    var emails = [String]()
    var timeStamps = [String]()
    var messagesKeys = [String]()
    var lastMessages = [String]()
    var lastMessage = String()
    
    
    
    override func viewDidLoad() {
        
        setNeedsStatusBarAppearanceUpdate()
        observeMessages()
        //tableView.allowsSelection = false
        
        
        
        
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(MessagesCell.self, forCellReuseIdentifier: "lol")
        tableView.separatorStyle = .none
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       /* if let emails = UserDefaults.standard.object(forKey: "emails") as? [String]{
            return emails.count
        }*/

        
        return toName.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lol", for: indexPath) as! MessagesCell
        cell.awakeFromNib()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.userName.text = emails[indexPath.row]
        cell.lastMessage.text = lastMessages[indexPath.row]
        //        let user = Auth.auth().currentUser?.uid
        DispatchQueue.main.async {
            /*
             var a = [String]()
             if user == self.toName[indexPath.row]{
             a = self.fromName
             } else {
             a = self.toName
             }*/
            
            if let emails = UserDefaults.standard.object(forKey: "emails") as? [String]{
                //cell.userName.text = emails[indexPath.row]
                //self.getNames(cell: cell, name: self.toName[indexPath.row])
                
            }else
            {
            //self.getNames(cell: cell, name: self.toName[indexPath.row])
            }
        }
        return cell
    }
    
    func getNames(cell: MessagesCell, name: String){
        let uid = Auth.auth().currentUser?.uid
        let aref = Database.database().reference().child("users").child(uid!).child("lastMessages").child(name)//.child("message")
        aref.queryOrdered(byChild: "timeStamp").observe( .value, with: { (snapshot) in
            
            let dictionary = snapshot.value as! [String: Any]
            let message = dictionary["message"] as! String
            //let timeStamp = dictionary["timeStamp"] as! Double
            
            cell.lastMessage.text = message
        }, withCancel: { (error) in
            
        })
        let ref = Database.database().reference().child("users").child(name)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String: Any]
            let email = dictionary["name"] as! String
            
            if self.emails.contains(email) == false{
                self.emails.append(email)
            }
            
            cell.userName.text = email
         
            //let ref = Database.database().reference().child("user-messages").child(uid!).child(name).queryLimited(toLast: 1)
            
//            ref.observe(.childAdded, with: { (snapshot) in
//                let messagesRef = Database.database().reference().child("messages").child(snapshot.key)
//                messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                    let dictionary = snapshot.value as! [String: Any]
//                    let message = dictionary["text"] as! String
//                    cell.lastMessage.text = message
//                }, withCancel: nil)
//            }, withCancel: nil)
            DispatchQueue.main.async {
                
                //UserDefaults.standard.set(self.emails, forKey: "emails")
            }
        })
    }
    

    
//    func getLastMessage(toId: String) {
//        let uid = Auth.auth().currentUser?.uid
//        let ref  = Database.database().reference().child("users").child(uid!).child("lastMessages")
//        
////        let ref = Database.database().reference().child("user-messages").child(uid!).child(toId).queryLimited(toLast: 1)
////        
//        ref.observe(.childAdded, with: { (snapshot) in
//            let messagesRef = Database.database().reference().child("messages").child(snapshot.key)
//            messagesRef.observe(.value, with: { (snapshot) in
//                print(snapshot)
////                let dictionary = snapshot.value as! [String: Any]
////                let message = dictionary["text"] as! String
//                
//            }, withCancel: nil)
//        }, withCancel: nil)
//    }
    
    func observeMessages(){
       
        let uid = Auth.auth().currentUser?.uid
        let userMessagesRef = Database.database().reference().child("users").child(uid!).child("lastMessages")
        userMessagesRef.queryOrdered(byChild: "timeStamp").observe( .value, with: { (snapshot) in
           
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.toName.removeAll()
            self.fromName.removeAll()
            self.lastMessages.removeAll()
            self.emails.removeAll()
            for snap in snapshots {
            
               
                if let name = snap.childSnapshot(forPath: "name").value as? String {
                    
                    self.emails.append(name)
                    self.toName.append(snap.key)
                    self.fromName.append(uid!)
                }
                if let message = snap.childSnapshot(forPath: "message").value as? String {
                    
                    self.lastMessages.append(message)
                }
            
            }
            
            
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.toName, forKey: "toName")
                self.tableView.reloadData()
            }
        }, withCancel: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Chat(collectionViewLayout: UICollectionViewFlowLayout())
        //  let allUsers = EveryUser()
        //   allUsers.toId = senderName[indexPath.row]
        if Auth.auth().currentUser?.uid == toName[indexPath.row]{
            vc.toId = fromName[indexPath.row]
            vc.fromID = toName[indexPath.row]
        } else {
            vc.toId = toName[indexPath.row]
            vc.fromID = fromName[indexPath.row]
        }
        
        DispatchQueue.main.async {
            self.show(vc, sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 12
    }
    
}
