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
     
        observeMessages()
 
        setUpInputComponents()
        setup()
        fromID = (Auth.auth().currentUser?.uid)!
    }
    
    func setup(){

        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = .white
        //collectionView?.transform = CGAffineTransformMakeScale(1, -1)
        //collectionView?.transform = __CGAffineTransformMake(1, 0, 0, -1, 0, 0)
        collectionView?.register(InfoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       // NotificationCenter.default.addObserver(self, selector: #selector(Chat.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Chat.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Chat.keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
   
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keybrdHeight = keyboardFrame.size.height
           
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - keybrdHeight)
            collectionView?.contentInset = UIEdgeInsets(top: 70 , left: 0, bottom: 58, right: 0)
            collectionView?.scrollIndicatorInsets = UIEdgeInsets(top:  70, left: 0, bottom: 50, right: 0)

            moveToLastComment()
            //do the chnages according ot this height
        }
    }
    
    var fromId = [String]()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        // kad paspaudus enter issiustu zinute
        textField.delegate = self
        
        
        return textField
    }()
    
    
    
    func keyboardWillHide(sender: NSNotification) {
        //self.view.frame.origin.y += keyboardHeight
        keyboardHeight = 0
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - keyboardHeight)
        collectionView?.contentInset = UIEdgeInsets(top: 70 , left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 70 , left: 0, bottom: 50, right: 0)
        
        moveToLastComment()

      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        //textField.resignFirstResponder()
        return true
    }
    
    
    func moveToLastComment() {
        if messages.count > 0{
            let item = messages.count - 1
            let lastIndex = IndexPath(item: item, section: 0)
            collectionView?.scrollToItem(at: lastIndex, at: .bottom, animated: true)
            }
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
                        
                       // self.moveToLastComment()

                    }
                })
            })
            
            
            }
        }
    }
    
    var messages = [String]()
    var messageName = [String]()
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(toId).queryLimited(toLast: 25)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId).queryOrdered(byChild: "timeStamp")
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                let message = dictionary["text"] as! String
                let fromIdd = dictionary["fromId"] as! String
                let toIdd = dictionary["toId"] as! String
                
                if (fromIdd == self.fromID && toIdd == self.toId) || (fromIdd == self.toId && toIdd == self.fromID) {
                    self.fromId.append(fromIdd)
                    
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(self.messages, forKey: "messages")
                        self.collectionView?.reloadData()
                        self.moveToLastComment()
                    }
                }
               
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
            cell.bubbleView.backgroundColor = UIColor(red: 255/255, green: 129/255, blue: 117/255, alpha: 0.6)
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
    
    
    
}
