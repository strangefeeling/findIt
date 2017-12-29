//
//  Chat.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 26/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"


class Chat: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var usserrr = String()
    var postId = String()
    var toId = String()
    var postName = String()
    let allUsers = EveryUser()
    var fromID = String()
    var keyboardHeight: CGFloat = 0
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        observeMessages()
        
        setUpInputComponents()
        setup()
        collectionView?.transform = CGAffineTransform(scaleX: 1, y: -1)
        fromID = (Auth.auth().currentUser?.uid)!
    }
    
    func setup(){
        
        
        //collectionView?.alwaysBounceVertical = true
        //collectionView?.allowsSelection = false
        collectionView?.contentInset = UIEdgeInsets(top: 58, left: 0, bottom: 8, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.backgroundColor = .white
        print("pradzioj ", collectionView?.contentInset, "edgeInsets ", collectionView?.scrollIndicatorInsets)

        collectionView?.register(InfoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // NotificationCenter.default.addObserver(self, selector: #selector(Chat.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //    NotificationCenter.default.addObserver(self, selector: #selector(Chat.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Chat.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide(sender:)))
        view.addGestureRecognizer(tap)
        
    }
    
    var e = 0
    
    func dismissKeyboard() {
        print("iiiiiiiiiiii ",e)
        if shouldKeyboardHeightChange == false {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            
            self.view.frame.origin.y += self.keyboardHeight
            self.view.endEditing(true)
            
            DispatchQueue.main.async {
                
                self.collectionView?.contentInset = UIEdgeInsetsMake(58, 0, self.keyboardHeight, 0)
                print("leidziames ",self.collectionView?.contentInset, "edgeInsets ", self.collectionView?.scrollIndicatorInsets)
                
                self.shouldKeyboardHeightChange = true
                
            }

            //print("view height is " , self.view.frame.height, " bottom inset is ", collectionView?.contentInset.bottom, " keyboard height is ", keyboardHeight , " collectionview, frame ", collectionView?.frame.height)
            
            // self.view.frame = CGRect(x: 0, y: 58, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 58)
            
            
        }
    }
 
    
    var shouldKeyboardHeightChange = true
    
    func keyboardWillShow(notification: NSNotification) {
        e += 1
        print("iiiiiiiiiiii ",e)
        
        if shouldKeyboardHeightChange { // nes kazkodel du kartus sita suda paleidzia
            self.shouldKeyboardHeightChange = false
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardHeight = keyboardSize.height
                
                self.view.frame.origin.y -= keyboardHeight
                DispatchQueue.main.async {
                    
                    self.collectionView?.contentInset = UIEdgeInsetsMake(58, 0, self.keyboardHeight + 8, 0)//.bottom = self.keyboardHeight + 8
                    self.collectionView?.scrollIndicatorInsets.bottom = self.keyboardHeight
                    
                    print("kylam ",self.collectionView?.contentInset, "edgeInsets ", self.collectionView?.scrollIndicatorInsets)
                    
                }
                
            }
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
//        UIView.animate(withDuration: 0.5) {
//            
//            self.view.frame.origin.y += self.keyboardHeight
//            DispatchQueue.main.async {
//                //self.collectionView?.contentInset.bottom -= self.keyboardHeight
//                print("leidziames ",self.collectionView?.contentInset.bottom )
//                self.keyboardHeight = 0
//            }
//            
//            
//        }
//        
//        
        print("iiiiiiiiiiii ",e)
        if shouldKeyboardHeightChange == false {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            
            self.view.frame = CGRect(x: 0, y: 58, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 58)
            
            
            DispatchQueue.main.async {
                
                self.collectionView?.contentInset = UIEdgeInsetsMake(58, 0, 8, 0)
                self.collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                print("leidziames ",self.collectionView?.contentInset, "edgeInsets ", self.collectionView?.scrollIndicatorInsets)
                
                self.shouldKeyboardHeightChange = true
                self.inputTextField.resignFirstResponder()
                //self.view.endEditing(true)
                
            }
            
            //print("view height is " , self.view.frame.height, " bottom inset is ", collectionView?.contentInset.bottom, " keyboard height is ", keyboardHeight , " collectionview, frame ", collectionView?.frame.height)
            
            // self.view.frame = CGRect(x: 0, y: 58, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 58)
            
            
        }

    }
    
    
    /* func keyboardWillChangeFrame(notification: NSNotification) {
     if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
     let keybrdHeight = keyboardFrame.size.height
     keyboardHeight = keybrdHeight
     self.view.frame = CGRect(x: 0, y: 58 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - keybrdHeight - 58)
     
     print("1 ","view height is " , self.view.frame.height, " bottom inset is ", collectionView?.contentInset.bottom, " keyboard height is ", keyboardHeight , " collectionview, frame ", collectionView?.frame.height)
     //collectionView?.invalidateIntrinsicContentSize()
     collectionView?.contentInset.bottom = -self.view.frame.height
     //  collectionView?.contentInset = UIEdgeInsets(top: 58 , left: 0, bottom: -keybrdHeight * 2 , right: 0)
     //  collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0 , left: 0, bottom: 0  , right: 0)
     collectionView?.setNeedsLayout()
     print("2 ","view height is " , self.view.frame.height, " bottom inset is ", collectionView?.contentInset.bottom, " keyboard height is ", keyboardHeight , " collectionview, frame ", collectionView?.frame.height)
     moveToLastComment()
     //do the chnages according ot this height
     }
     }*/
    
    /*   func keyboardWillHide(sender: NSNotification) {
     //self.view.frame.origin.y += keyboardHeight
     
     self.view.frame = CGRect(x: 0, y: 58, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
     collectionView?.invalidateIntrinsicContentSize()
     collectionView?.contentInset.bottom = keyboardHeight * 2
     //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 58, left: 0, bottom: 8, right: 0)
     collectionView?.setNeedsLayout()
     
     // collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50 , left: 0, bottom: 70 + keyboardHeight, right: 0)
     
     keyboardHeight = 0
     
     moveToLastComment()
     
     
     }*/

    
    var fromId = [String]()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type a message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        // kad paspaudus enter issiustu zinute
        textField.delegate = self
        
        
        return textField
    }()
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        //textField.resignFirstResponder()
        return true
    }
    
    
    func moveToLastComment() {
        /*  if messages.count > 0{
         let item = messages.count - 1
         let lastIndex = IndexPath(item: item, section: 0)
         collectionView?.scrollToItem(at: lastIndex, at: .bottom, animated: true)
         }*/
    }
    
    func setUpInputComponents(){
        let containerView = UIView()
        
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50) .isActive = true
        
        //send button, type, kad mirksetu mygtukas, kai paspaudi
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // textfield
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //separator line
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.centerYAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func handleSend(){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let uid = Auth.auth().currentUser?.uid
        if let message = inputTextField.text{
            if message != ""{
                self.inputTextField.text = ""
                let userInfoRef = Database.database().reference().child("users").child(uid!)
                userInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as! [String: Any]
                    
                    
                    let values = ["text": message, "toId": self.toId,"fromId": self.fromID, "timeStamp": timeStamp ] as [String : Any]
                    childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print(error)
                            return
                        }
                        let userMessagesref = Database.database().reference().child("user-messages").child(self.fromID).child(self.toId)
                        let messageId = childRef.key
                        userMessagesref.updateChildValues([messageId: 1])
                        
                        let recipientUseressagesRef = Database.database().reference().child("user-messages").child(self.toId).child(self.fromID)
                        recipientUseressagesRef.updateChildValues([messageId: 1])
                        DispatchQueue.main.async {
                            
                            self.moveToLastComment()
                            
                        }
                    })
                })
                
                
            }
        }
    }
    
    var messages = [String]()
    var messageName = [String]()
    var a = 15
    var times = [Double]()
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(toId).queryLimited(toLast: UInt(a))
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId).queryOrdered(byChild: "timeStamp")
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                let message = dictionary["text"] as! String
                let fromIdd = dictionary["fromId"] as! String
                let toIdd = dictionary["toId"] as! String
                let time = dictionary["timeStamp"] as! Double
                
                
                if (fromIdd == self.fromID && toIdd == self.toId) || (fromIdd == self.toId && toIdd == self.fromID) {
                    self.fromId.insert(fromIdd, at: 0)
                    self.times.insert(time, at: 0)
                    self.messages.insert(message, at: 0)
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(self.messages, forKey: "messages")
                        self.collectionView?.reloadData()
                        self.moveToLastComment()
                        
                    }
                }
                //                DispatchQueue.main.async {
                //                    self.fromId.reverse()
                //                    self.times.reverse()
                //                    self.messages.reverse()
                //                    self.collectionView?.reloadData()
                //                }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        // get the estimated height
        let text = messages[indexPath.item]
        height = estimatedFrameForText(text: text).height
        
        return CGSize(width: view.frame.width, height: height + 20)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect{
        //200 nes chatmessagecelle toks, o 1000, nes px ir reik didelio
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return messages.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InfoCell
        
        // cell.leftAnchor()
        
        let message = messages[indexPath.item]
        cell.textView.text = messages[indexPath.item]
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message).width + 32
        
        if fromId[indexPath.row] == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = myColor//UIColor(patternImage: UIImage(named: "redBubble")!)//myColor//UIColor(red: 255/255, green: 129/255, blue: 117/255, alpha: 0.6)
            cell.textView.textColor = .white
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else{
            cell.bubbleView.backgroundColor = UIColor(red: 210/255, green: 235/255, blue: 1, alpha: 1)//.yellow
            cell.textView.textColor = .darkGray
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        // cell.backgroundColor = .blue
        // Configure the cell
        
        
        return cell
    }
    
    
    
    
    
    func addMoreMessages(){
        a += 10
        var i = 0
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(toId).queryLimited(toLast: UInt(a))
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId).queryOrdered(byChild: "timeStamp")
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                // print(snapshot)
                let message = dictionary["text"] as! String
                let fromIdd = dictionary["fromId"] as! String
                let toIdd = dictionary["toId"] as! String
                let time = dictionary["timeStamp"] as! Double
                //print(time)
                
                if self.times.contains(time) == false {
                    
                    if (fromIdd == self.fromID && toIdd == self.toId) || (fromIdd == self.toId && toIdd == self.fromID) {
                        
                        // + i, kad nebutu atvirksciai uzloadintos naujos zinutes
                        self.fromId.insert(fromIdd, at: self.fromId.count - i)
                        self.times.insert(time, at: self.times.count - i)
                        self.messages.insert(message, at: self.messages.count - i)
                        i += 1
                    }
                }
                DispatchQueue.main.async {
                    
                    self.collectionView?.reloadData()
                    // print(self.timeToreverse)
                    
                }
            }, withCancel: nil)
            
            
            
            
            
        }, withCancel: nil)
        
    }
    
    var i = 0
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if messages.count > 14{
            if messages.count >= i {
                let lastItem = messages.count - 1
                if indexPath.item == lastItem {
                    i += 15
                    
                    addMoreMessages()
                }
            }
        }
    }
    
    
}
