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
    var chatPartnerNamwe = String()
    
    var shouldKeyboardChangeFrame = true
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        observeMessages()
        
        getChatPartnersId()
        setUpInputComponents()
        setup()
        collectionView?.transform = CGAffineTransform(scaleX: 1, y: -1)
        fromID = (Auth.auth().currentUser?.uid)!
    }
    func getChatPartnersId(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(toId).child("name")
        
        ref.observe(.value, with: { (snapshot) in
             self.chatPartnerNamwe = snapshot.value as! String
            
        })
    }
    
    func setup(){
        collectionView?.alwaysBounceVertical = true
        //collectionView?.allowsSelection = false
        collectionView?.contentInset = UIEdgeInsets(top: 58, left: 0, bottom: 8, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.backgroundColor = .white
        

        collectionView?.register(InfoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // NotificationCenter.default.addObserver(self, selector: #selector(Chat.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //    NotificationCenter.default.addObserver(self, selector: #selector(Chat.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Chat.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        collectionView?.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        
    }
    
    var e = 0
    
  func dismissKeyboard() {
     self.view.endEditing(true)
     self.view.frame = CGRect(x: 0, y: 58, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 58)
    shouldKeyboardChangeFrame = true
    }
 
    
    var shouldKeyboardHeightChange = true
    
    func keyboardWillShow(notification: NSNotification) {
        e += 1
        //if shouldKeyboardChangeFrame{
        
        
      // nes kazkodel du kartus sita suda paleidzia
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardHeight = keyboardSize.height
                
                self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - keyboardHeight)
                shouldKeyboardChangeFrame = false
                DispatchQueue.main.async {
                    
                    
                    self.collectionView?.contentInset = UIEdgeInsetsMake(58, 0, self.keyboardHeight - 8 - 58, 0)//.bottom = self.keyboardHeight + 8
                    self.collectionView?.scrollIndicatorInsets.top = self.keyboardHeight
                    
                    
                    
                }
                
            }
        //}
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
         //self.view.endEditing(true)
        //if shouldKeyboardChangeFrame == false {
            self.shouldKeyboardChangeFrame = true
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            
           // self.view.frame = CGRect(x: 0, y: 58, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 58)
            
            
            
                
                self.collectionView?.contentInset = UIEdgeInsets(top: 58, left: 0, bottom: 8, right: 0)
                self.collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
                
            
                //self.inputTextField.resignFirstResponder()
            
                
            
       
            
            
            
            
      //  }

    }
    
    
   

    
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
        let usersRef = Database.database().reference().child("users").child(fromID).child("lastMessages").child(toId)
        let recipientsRef = Database.database().reference().child("users").child(toId).child("lastMessages").child(fromID)
        
        if let message = inputTextField.text{
            if message != ""{
                let currUser = UserDefaults.standard.string(forKey: "email")
                usersRef.child("message").setValue(inputTextField.text)
                recipientsRef.child("message").setValue(inputTextField.text)
                recipientsRef.child("timeStamp").setValue(timeStamp * -1)
                usersRef.child("timeStamp").setValue(timeStamp * -1)
                usersRef.child("name").setValue(chatPartnerNamwe)
                recipientsRef.child("name").setValue(currUser)
                
                self.inputTextField.text = ""
                let userInfoRef = Database.database().reference().child("users").child(uid!)
                userInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as! [String: Any]
                    
                    
                    //set(email, forKey: "email")
                    
                    
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
        a += 15
        var i = 0
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
                    userMessageRef.removeAllObservers()
                    messagesRef.removeAllObservers()
                    
                    
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
