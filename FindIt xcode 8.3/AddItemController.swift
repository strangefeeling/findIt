//
//  PostItemViewController.swift
//  ex
//
//  Created by Rytis on 05/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

var didUserJustPosted = false

class AddItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var imageToPost: UIImage?
    let allItems = AllItems()
    var isUserEditing = false
    var editPostName = ""
    
    let backButton: UIButton = {
       let button = UIButton()//(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        view.image = patternImage
        return view
    }()
    
    let deleteButton: UIButton = {
       let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    var whoFollows = [String]()
    
    @objc func deletePost(){
        print("susirasi darba")
       let ref = Database.database().reference().child("allPosts").child(foundOrLost).child(postName)
        ref.removeValue()
        let imageRef = Storage.storage().reference(forURL: imageUrl)
        imageRef.delete(completion: { (error) in
            print(error as Any)
        })
        let refer = Database.database().reference().child("allPosts").child("comments").child(postName)
        let commentRef = refer
        commentRef.removeValue()
        let userRef = Database.database().reference().child("users")
        userRef.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                
                if dict["followed"] != nil{
                    print(snapshot.key)
                    self.deleteUsersFollowedPost(user: snapshot.key)
               // print(dict["followed"])
                }
            }
        })
    }
    
    func deleteUsersFollowedPost(user: String){
        let ref = Database.database().reference().child("users").child(user).child("followed").child(postName)
       /* ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
        })*/
        let anotherRef = ref
        anotherRef.removeValue()
        
    }
    
    @objc func goBack()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        if isUserEditing {
            print("user is editing")
            postButton.setTitle("Edit", for: .normal)
            postButton.addTarget(self, action: #selector(getEmail), for: .touchUpInside)
            view.addSubview(deleteButton)
            deleteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 33.35).isActive = true
            deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
            deleteButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
            deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            print(isUserEditing)
        } else {
            postButton.addTarget(self, action: #selector(postToServer), for: .touchUpInside)
        }
        
       // view.backgroundColor = UIColor(patternImage: patternImage!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupView()
        print("image url ", imageUrl)
        
    }
    
    var shouldKeyboardHeightChange = true
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if shouldKeyboardHeightChange {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            self.view.frame.origin.y -= keyboardHeight
            self.shouldKeyboardHeightChange = false
          //  self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - keyboardHeight)
            
        }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.view.frame.origin.y += self.keyboardHeight
            self.shouldKeyboardHeightChange = true
        }
        
        keyboardHeight = 0
        
    }
    
    let mySwitch: UISwitch = {
       let mySwitch = UISwitch()
        mySwitch.onTintColor = .yellow
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        return mySwitch
    }()
    
    let lostLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Lost"
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()
    
    let foundLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Found"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()
    


    var keyboardHeight: CGFloat = 0
    
    
    
    let tempButtonWithImage: UIButton = {
        let tbwi = UIButton()
        tbwi.translatesAutoresizingMaskIntoConstraints = false
        tbwi.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        tbwi.imageView?.contentMode = .scaleAspectFit
        tbwi.tintColor = UIColor.white
        tbwi.addTarget(self, action: #selector(postPhoto), for: .touchUpInside)
        
        return tbwi
    }()
    
    let openMapsButton: UIButton = {
       
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setTitle("Add Location", for: .normal)
        button.addTarget(self, action: #selector(toMaps), for: .touchUpInside)
        
        return button
    
    }()
    
    let itemDescription: UITextField = {
        let id = UITextField()
        let borderColor = UIColor.white
        id.translatesAutoresizingMaskIntoConstraints = false
        id.placeholder = "Describe your item..."
        id.textAlignment = .natural
        id.layer.borderWidth = 1
        id.layer.borderColor = borderColor.cgColor
        id.layer.cornerRadius = 10
        id.font = UIFont(name: "Avenir Next", size: 20)
        
        return id
    }()
    
    let postButton: UIButton = {
        let pb = UIButton()
        pb.setTitle("Post", for: .normal)
        pb.titleLabel?.font = UIFont(name: "Anevir Next", size: 20)
       // pb.addTarget(self, action: #selector(postToServer), for: .touchUpInside)
        pb.tintColor = UIColor.white
        pb.titleLabel?.textAlignment = .center
        pb.translatesAutoresizingMaskIntoConstraints = false
        
        return pb
    }()
    
    func toMaps(){
        let map = MapController()
        dismissKeyboard()
        //show(map, sender: self)
        present(map, animated: true, completion: nil)
    }
    
    func post(){
      
        if imageToPost != nil && itemDescription.text != ""{
            
            let imageName = NSUUID().uuidString
            let postName = NSUUID().uuidString
            let imagesFolder = Storage.storage().reference().child("images")
            
            if let imageData = UIImageJPEGRepresentation(imageToPost!, 0.1){
                imagesFolder.child("\(imageName).jpg").putData(imageData, metadata: nil, completion:{
                    (metadata, error) in
                    
                    if let error = error{
                        // self.presentAlert(alert: error.localizedDescription)
                        print(error)
                    } else{
                        if let downloadURL =  metadata?.downloadURL()?.absoluteString {
                            let timeStamp = Int(NSDate().timeIntervalSince1970)
                            let currUser = Auth.auth().currentUser?.uid
                            //   let ref = Database.database().reference().child("posts").child(currUser!).child(postName)
                            let lat = UserDefaults.standard.string(forKey: "lat")
                            let lon = UserDefaults.standard.string(forKey: "lon")
                            let locationName = UserDefaults.standard.string(forKey: "title")
                            let city = UserDefaults.standard.string(forKey: "city")
                            var allRef = Database.database().reference().child("allPosts")
                            if self.mySwitch.isOn{
                                allRef = Database.database().reference().child("allPosts").child("found").child(postName)
                            } else {
                              allRef = Database.database().reference().child("allPosts").child("lost").child(postName)
                            }
                            
                            
                            //.child(postName)
                            //allRef.setValue(currUser!)
                            /*  ref.child("downloadURL").setValue(downloadURL)
                             ref.child("description").setValue(self.itemDescription.text!)
                             ref.child("timeStamp").setValue(timeStamp)*/
                            // allRef.child(currUser!).setValue(currUser!)
                            allRef.child("downloadURL").setValue(downloadURL)
                            allRef.child("description").setValue(self.itemDescription.text!)
                            allRef.child("timeStamp").setValue(timeStamp)
                            allRef.child("uid").setValue(currUser!)
                            allRef.child("email").setValue(self.myEmail)
                            if lon != nil{
                                allRef.child("lon").setValue(lon)
                                allRef.child("lat").setValue(lat)
                                allRef.child("locationName").setValue(locationName)
                                allRef.child("city").setValue(city)
                            } else {
                                allRef.child("lon").setValue("53")
                                allRef.child("lat").setValue("53")
                                allRef.child("locationName").setValue("unknown")
                                allRef.child("city").setValue("unknown")
                            }
                            
                            
                        }
                        DispatchQueue.main.async {
                            
                            didUserJustPosted = true
                            
                            UserDefaults.standard.removeSuite(named: "lat")
                            UserDefaults.standard.removeSuite(named: "lon")
                            UserDefaults.standard.removeSuite(named: "title")
                            UserDefaults.standard.removeSuite(named: "city")
                            //let myCell = SecondPage()
                            //myCell.collectionView?.reloadData()
                            
                            self.dismiss(animated: true, completion: nil)
                            //self.navigationController?.popViewController(animated: true)
                            
                        }

                    }
                })
             
                
            }
            
        }
        
    }
    
    var myEmail = String()
    
    @objc func postToServer(){
        var i = 0
        let currUser = Auth.auth().currentUser?.uid
       // if isUserEditing == false{
        
        let myRef = Database.database().reference().child("users").child(currUser!)
            myRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String: Any]
            
            self.myEmail = dict["email"] as! String
            DispatchQueue.main.async {
                self.post()
            }
        })
       // } else {
      /*      let myRef = Database.database().reference().child("users").child(currUser!)
            myRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let dict = snapshot.value as! [String: Any]
                
                self.myEmail = dict["email"] as! String
                DispatchQueue.main.async {
                    self.editPost()
                }
            })*/
       // }
    }
    
    func getEmail(){
        let currUser = Auth.auth().currentUser?.uid
        let myRef = Database.database().reference().child("users").child(currUser!)
        myRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String: Any]
            
            self.myEmail = dict["email"] as! String
            DispatchQueue.main.async {
                self.editPost()
            }
        })

    }
    
    func editPost(){
        if imageToPost != nil && itemDescription.text != ""{
            
            
            if mySwitch.isOn && foundOrLost == "found" || mySwitch.isOn == false && foundOrLost == "lost"{//found, lost
                //print("nepakeite", mySwitch.isOn)
               
              print("nepakeite")
                let imageName = NSUUID().uuidString
                let postName = editPostName
                let imagesFolder = Storage.storage().reference().child("images")
                
                if let imageData = UIImageJPEGRepresentation(imageToPost!, 0.1){
                    imagesFolder.child("\(imageName).jpg").putData(imageData, metadata: nil, completion:{
                        (metadata, error) in
                        
                        if let error = error{
                            // self.presentAlert(alert: error.localizedDescription)
                            print(error)
                        } else{
                            if let downloadURL =  metadata?.downloadURL()?.absoluteString {
                                let timeStamp = Int(NSDate().timeIntervalSince1970)
                                let currUser = Auth.auth().currentUser?.uid
                                //   let ref = Database.database().reference().child("posts").child(currUser!).child(postName)
                                let lat = UserDefaults.standard.string(forKey: "lat")
                                let lon = UserDefaults.standard.string(forKey: "lon")
                                let locationName = UserDefaults.standard.string(forKey: "title")
                                let city = UserDefaults.standard.string(forKey: "city")
                                var allRef = Database.database().reference().child("allPosts").child(foundOrLost).child(postName)
                                /* if self.mySwitch.isOn{
                                 allRef = Database.database().reference().child("allPosts").child("found").child(postName)
                                 } else {
                                 allRef = Database.database().reference().child("allPosts").child("lost").child(postName)
                                 }*/
                                
                                //.child(postName)
                                //allRef.setValue(currUser!)
                                /*  ref.child("downloadURL").setValue(downloadURL)
                                 ref.child("description").setValue(self.itemDescription.text!)
                                 ref.child("timeStamp").setValue(timeStamp)*/
                                // allRef.child(currUser!).setValue(currUser!)
                                allRef.child("downloadURL").setValue(downloadURL)
                                allRef.child("description").setValue(self.itemDescription.text!)
                                allRef.child("timeStamp").setValue(timeStamp)
                                allRef.child("uid").setValue(currUser!)
                                //allRef.child("email").setValue(self.myEmail)
                                allRef.child("lon").setValue(lon)
                                allRef.child("lat").setValue(lat)
                                allRef.child("locationName").setValue(locationName)
                                allRef.child("city").setValue(city)
                                
                            }
                            DispatchQueue.main.async {
                                
                                didUserJustPosted = true
                                
                                UserDefaults.standard.removeSuite(named: "lat")
                                UserDefaults.standard.removeSuite(named: "lon")
                                UserDefaults.standard.removeSuite(named: "title")
                                UserDefaults.standard.removeSuite(named: "city")
                                //let myCell = SecondPage()
                                //myCell.collectionView?.reloadData()
                                
                                self.dismiss(animated: true, completion: nil)
                                //self.navigationController?.popViewController(animated: true)
                                
                            }
                            
                        }
                    })
                    
                    
                }


            }
            else if mySwitch.isOn == false && foundOrLost == "found" || mySwitch.isOn && foundOrLost == "lost" { //lost
                print("pakeite")
                let ref = Database.database().reference().child("allPosts").child(foundOrLost).child(postName)
                ref.removeValue()
                let imageName = NSUUID().uuidString
                let imageRef = Storage.storage().reference(forURL: imageUrl)
                imageRef.delete(completion: { (error) in
                    print(error as Any)
                })
                
                
                let imagesFolder = Storage.storage().reference().child("images")
                
                if let imageData = UIImageJPEGRepresentation(imageToPost!, 0.1){
                    imagesFolder.child("\(imageName).jpg").putData(imageData, metadata: nil, completion:{
                        (metadata, error) in
                        
                        if let error = error{
                            // self.presentAlert(alert: error.localizedDescription)
                            print(error)
                        } else{
                            if let downloadURL =  metadata?.downloadURL()?.absoluteString {
                                let timeStamp = Int(NSDate().timeIntervalSince1970)
                                let currUser = Auth.auth().currentUser?.uid
                                //   let ref = Database.database().reference().child("posts").child(currUser!).child(postName)
                                let lat = UserDefaults.standard.string(forKey: "lat")
                                let lon = UserDefaults.standard.string(forKey: "lon")
                                let locationName = UserDefaults.standard.string(forKey: "title")
                                let city = UserDefaults.standard.string(forKey: "city")
                                var allRef = Database.database().reference().child("allPosts")
                                if self.mySwitch.isOn{
                                    allRef = Database.database().reference().child("allPosts").child("found").child(postName)
                                    
                                } else {
                                    allRef = Database.database().reference().child("allPosts").child("lost").child(postName)
                                    
                                }
                                
                                
                                //.child(postName)
                                //allRef.setValue(currUser!)
                                /*  ref.child("downloadURL").setValue(downloadURL)
                                 ref.child("description").setValue(self.itemDescription.text!)
                                 ref.child("timeStamp").setValue(timeStamp)*/
                                // allRef.child(currUser!).setValue(currUser!)
                                allRef.child("downloadURL").setValue(downloadURL)
                                allRef.child("description").setValue(self.itemDescription.text!)
                                allRef.child("timeStamp").setValue(timeStamp)
                                allRef.child("uid").setValue(currUser!)
                                allRef.child("email").setValue(self.myEmail)
                                allRef.child("lon").setValue(lon)
                                allRef.child("lat").setValue(lat)
                                allRef.child("locationName").setValue(locationName)
                                allRef.child("city").setValue(city)
                                
                            }
                            DispatchQueue.main.async {
                                
                                didUserJustPosted = true
                                
                                UserDefaults.standard.removeSuite(named: "lat")
                                UserDefaults.standard.removeSuite(named: "lon")
                                UserDefaults.standard.removeSuite(named: "title")
                                UserDefaults.standard.removeSuite(named: "city")
                                //let myCell = SecondPage()
                                //myCell.collectionView?.reloadData()
                                
                                self.dismiss(animated: true, completion: nil)
                                //self.navigationController?.popViewController(animated: true)
                                
                            }
                            
                        }
                    })
                    
                    
                }

            }
            
        }
    }
    
    /* if
     

 */
    
    /*  else
    
     */
    
    func setupView(){
        view.addSubview(backButton)
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -UIScreen.main.bounds.height / 33.35).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 33.35).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(tempButtonWithImage)
        
        tempButtonWithImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempButtonWithImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 4 * UIScreen.main.bounds.height / 33.35).isActive = true
        tempButtonWithImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
        tempButtonWithImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3.2).isActive = true
        
    
        view.addSubview(openMapsButton)
        
        openMapsButton.topAnchor.constraint(equalTo: tempButtonWithImage.bottomAnchor, constant: 8).isActive = true
        openMapsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openMapsButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2 ).isActive = true
        openMapsButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 12).isActive = true
        
        view.addSubview(itemDescription)
        
        itemDescription.topAnchor.constraint(equalTo: openMapsButton.bottomAnchor, constant: 4).isActive = true
        itemDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        itemDescription.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
        itemDescription.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 5).isActive = true
       
        view.addSubview(mySwitch)
        
        mySwitch.topAnchor.constraint(equalTo: itemDescription.bottomAnchor, constant: 10).isActive = true
        mySwitch.centerXAnchor.constraint(equalTo: itemDescription.centerXAnchor).isActive = true
        mySwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mySwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(lostLabel)
        
        lostLabel.rightAnchor.constraint(equalTo: mySwitch.leftAnchor, constant: -8).isActive = true
        lostLabel.topAnchor.constraint(equalTo: mySwitch.topAnchor).isActive = true
        lostLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lostLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(foundLabel)
        
        foundLabel.leftAnchor.constraint(equalTo: mySwitch.rightAnchor, constant: 8).isActive = true
        foundLabel.topAnchor.constraint(equalTo: mySwitch.topAnchor).isActive = true
        foundLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        foundLabel.widthAnchor.constraint(equalToConstant: 60).isActive  = true

        view.addSubview(postButton)
        postButton.topAnchor.constraint(equalTo: mySwitch.bottomAnchor, constant: 10).isActive = true
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        /*
         
     /*   */
        
       */
    }
    
    @objc func postPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    // status bar spalva keiciam
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            tempButtonWithImage.setImage((image), for: .normal)
            imageToPost = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
}

