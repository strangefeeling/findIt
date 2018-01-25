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
var shouldIDismiss = false

class AddItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var imageToPost: UIImage?
    // let allItems = AllItems()
    var isUserEditing = false
    var editPostName = ""
    var cityForEdit = ""
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        //indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        return indicator
    }()
    
    let backButton: UIButton = {
        let button = UIButton()//(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.setTitleColor(myTextColor, for: .normal)
        return button
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
        
        presentAlert(alert: "Item will be deletd permanently")
        
    }
    
    
    func deleteUsersFollowedPost(user: String){
        let ref = Database.database().reference().child("users").child(user).child("followed").child(postName)
        let bRef = Database.database().reference().child("users").child(user).child("myPosts").child(postName)
        /* ref.observeSingleEvent(of: .value, with: { (snapshot) in
         print(snapshot)
         })*/
        let anotherRef = ref
        let b = bRef
        b.removeValue()
        anotherRef.removeValue()
        
    }
    
    @objc func goBack()
    {   itemDescription.text = ""
        tempButtonWithImage.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        imageToPost = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    var info: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"information")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.tintColor = myTextColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showExplanation), for: .touchUpInside)
        
        return button
    }()
    
    let infoText: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Add the location of where the item was found. If you are looking for an item, just select a location anywhere in your city area."
        text.font = UIFont(name: "Avenir Next", size: 16)
        text.layer.cornerRadius = 20
        text.textColor = .darkGray
        text.isEditable = false
        text.isScrollEnabled = false
        text.alpha = 0
        return text
    }()
    
    let dimScreen: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    func showExplanation(){
        infoBool = !infoBool
    }
    
    var infoBool: Bool = false {
        didSet {
            
            
            
            if infoBool{
                view.addSubview(dimScreen)
                infoTextConstraints()
                infoText.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                infoText.center = info.center
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.dimScreen.alpha = 0.6
                    self.infoText.center = self.view.center
                    self.infoText.transform = CGAffineTransform(scaleX: 1, y: 1)
                    
                    //self.infoText.center.x = self.view.center.x
                    self.infoText.alpha = 1
                })
                
            } else {
                
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.dimScreen.alpha = 0
                    self.infoText.center = self.info.center
                    self.infoText.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    
                }, completion: { (true) in
                    self.infoText.removeFromSuperview()
                    self.dimScreen.removeFromSuperview()
                })
                
                
            }
        }
    }
    
    
    var myConstraint =  NSLayoutConstraint()
    
    func infoTextConstraints(){
        view.addSubview(infoText)
        myConstraint =  infoText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        myConstraint.isActive = true
        infoText.widthAnchor.constraint(equalToConstant: 270).isActive = true
        infoText.heightAnchor.constraint(equalToConstant: 110).isActive = true
        infoText.bottomAnchor.constraint(equalTo: info.topAnchor, constant: -16).isActive = true
    }
    
    func beGone(){
        print("susirasi darba")
        shouldIDismiss = true
        let ref = Database.database().reference().child("allPosts").child(foundOrLost).child(postName)
        let cityRef = Database.database().reference().child("allPosts").child(foundOrLost).child(cityForEdit.folding(options: .diacriticInsensitive, locale: .current).capitalized).child(postName)
        ref.removeValue()
        cityRef.removeValue()
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
                
                //                if dict["followed"] != nil{
                //print(snapshot.key)
                self.deleteUsersFollowedPost(user: snapshot.key)
                
                self.dismiss(animated: true, completion: nil)
                
                // print(dict["followed"])
                //                }
            }
        })
        
    }
    
    func emptyPostAlert(alert: String){
        let alertVc = UIAlertController(title: "You must fill all the required fields!", message: alert, preferredStyle: .alert)
        activityIndicator.stopAnimating()
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVc.dismiss(animated: true, completion: nil)
            
        }
        alertVc.addAction(okAction)
        present(alertVc, animated: true, completion: nil)
    }
    
    func presentAlert(alert:String){
        let alertVC = UIAlertController(title: "Do you really want to delete this item?", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.beGone()
            
            alertVC.dismiss(animated: true, completion: nil)
            //UserDefaults.standard.removeObject(forKey: "emails")
            //self.performSegue(withIdentifier: "lll", sender: self)
        }
        let cancelAction = UIAlertAction(title: "No", style: .default) { (action) in
            
            
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = myColor
        activityIndicator.center = view.center
        // view.backgroundColor = UIColor(patternImage: patternImage!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showExplanation))
        dimScreen.addGestureRecognizer(tap2)
        print(cityForEdit.capitalized,"<------")
        setupView()
        if isUserEditing {
            print("user is editing")
            postButton.setTitle("Edit", for: .normal)
            postButton.addTarget(self, action: #selector(getEmail), for: .touchUpInside)
            view.addSubview(deleteButton)
            if foundOrLost == "lost" {
                mySwitch.isOn = false
            } else {
                mySwitch.isOn = true
            }
            deleteButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 0).isActive = true
            deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
            deleteButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
            deleteButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            print(isUserEditing)
        } else {
            postButton.addTarget(self, action: #selector(postToServer), for: .touchUpInside)
        }
        
        //print("image url ", imageUrl)
        
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
        label.textColor = myTextColor
        label.text = "Lost"
        label.font = UIFont(name: "Avenir Next", size: 20)
        
        return label
    }()
    
    let foundLabel: UILabel = {
        let label = UILabel()
        label.textColor = myTextColor
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
        tbwi.tintColor = myTextColor
        tbwi.addTarget(self, action: #selector(postPhoto), for: .touchUpInside)
        
        return tbwi
    }()
    
    let openMapsButton: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = myTextColor
        button.setTitle("Add Location", for: .normal)
        button.addTarget(self, action: #selector(toMaps), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        //button.layer.borderWidth = 1
        //button.layer.borderColor = myTextColor.cgColor
        return button
        
    }()
    
    let itemDescription: UITextField = {
        let id = UITextField()
        let borderColor = myTextColor
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
        pb.setTitleColor(myTextColor, for: .normal)
        pb.translatesAutoresizingMaskIntoConstraints = false
        pb.backgroundColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        pb.setTitleColor(UIColor.white, for: .normal)
        pb.layer.cornerRadius = 5
       // pb.layer.borderWidth = 1
        //pb.layer.borderColor = myTextColor.cgColor
        return pb
    }()
    
    func toMaps(){
        let map = MapController()
        dismissKeyboard()
        //show(map, sender: self)
        present(map, animated: true, completion: nil)
    }
    
    func post(){
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        if  itemDescription.text != "" && UserDefaults.standard.string(forKey: "lat") != nil {
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            if  itemDescription.text != ""{
                
                let imageName = NSUUID().uuidString
                let postName = NSUUID().uuidString
                let imagesFolder = Storage.storage().reference().child("images")
                
                if imageToPost == nil {
                    imageToPost = UIImage(named: "camera")
                }
                
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
                                let cityForSearch = city?.folding(options: .diacriticInsensitive, locale: .current).capitalized
                                var allRef = Database.database().reference().child("allPosts")
                                var isItFoundOrLost = ""
                                var anotherRef = allRef
                                if self.mySwitch.isOn{
                                    allRef = Database.database().reference().child("allPosts").child("found").child(cityForSearch!).child(postName)
                                    anotherRef = Database.database().reference().child("allPosts").child("found").child(postName)
                                    isItFoundOrLost = "found"
                                } else {
                                    allRef = Database.database().reference().child("allPosts").child("lost").child(cityForSearch!).child(postName)
                                    anotherRef = Database.database().reference().child("allPosts").child("lost").child(postName)
                                    isItFoundOrLost = "lost"
                                }
                                
                                let myRef = Database.database().reference().child("users").child(currUser!).child("myPosts").child(postName)
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
                                allRef.child("name").setValue(self.myEmail)
                                allRef.child("foundOrLost").setValue(isItFoundOrLost)
                                allRef.child("city").setValue(city)
                                allRef.child("locationName").setValue(locationName)
                                allRef.child("lat").setValue(lat)
                                allRef.child("lon").setValue(lon)
                                
                                anotherRef.child("downloadURL").setValue(downloadURL)
                                anotherRef.child("description").setValue(self.itemDescription.text!)
                                anotherRef.child("timeStamp").setValue(timeStamp)
                                anotherRef.child("uid").setValue(currUser!)
                                anotherRef.child("name").setValue(self.myEmail)
                                anotherRef.child("foundOrLost").setValue(isItFoundOrLost)
                                anotherRef.child("city").setValue(city)
                                anotherRef.child("locationName").setValue(locationName)
                                anotherRef.child("lat").setValue(lat)
                                anotherRef.child("lon").setValue(lon)
                                
                                myRef.child("timeStamp").setValue(timeStamp * -1)
                                myRef.child("foundOrLost").setValue(isItFoundOrLost)
                                myRef.child("downloadURL").setValue(downloadURL)
                                myRef.child("description").setValue(self.itemDescription.text!)
                                myRef.child("uid").setValue(currUser!)
                                myRef.child("name").setValue(self.myEmail)
                                myRef.child("locationName").setValue(locationName)
                                myRef.child("city").setValue(city)
   
                                
                            }
                            DispatchQueue.main.async {
                                
                                didUserJustPosted = true
                                
                                //let myCell = SecondPage()
                                //myCell.collectionView?.reloadData()
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.goBack()
                                //self.dismiss(animated: true, completion: nil)
                                //self.navigationController?.popViewController(animated: true)
                                
                            }
                            
                        }
                    })
                    
                    
                }
                
            }
        } else {
            self.emptyPostAlert(alert: "Make sure to add location and description")
        }
        
    }
    
    var myEmail = String()
    
    @objc func postToServer(){
        
        let currUser = Auth.auth().currentUser?.uid
        // if isUserEditing == false{
        
        let myRef = Database.database().reference().child("users").child(currUser!)
        myRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String: Any]
            
            self.myEmail = dict["name"] as! String
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
            
            self.myEmail = dict["name"] as! String
            DispatchQueue.main.async {
                self.editPost()
            }
        })
        
    }
    
    func editPost(){
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        view.addSubview(activityIndicator)
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
                                //let cityForSearch = city?.folding(options: .diacriticInsensitive, locale: .current).capitalized
                                let allRef = Database.database().reference().child("allPosts").child(foundOrLost).child(postName)
                                let cityRef = Database.database().reference().child("allPosts").child(foundOrLost).child(self.cityForEdit).child(postName)
                                let myRef = Database.database().reference().child("users").child(currUser!).child("myPosts").child(postName)
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
                                allRef.child("name").setValue(self.myEmail)
                                allRef.child("lon").setValue(lon)
                                allRef.child("lat").setValue(lat)
                                allRef.child("locationName").setValue(locationName)
                                allRef.child("city").setValue(city)
                                // allRef.child("cityForSearch").setValue(cityForSearch)
                                
                                myRef.child("timeStamp").setValue(timeStamp * -1)
                                myRef.child("downloadURL").setValue(downloadURL)
                                myRef.child("description").setValue(self.itemDescription.text!)
                                myRef.child("uid").setValue(currUser!)
                                myRef.child("name").setValue(self.myEmail)
                                myRef.child("locationName").setValue(locationName)
                                myRef.child("city").setValue(city)
                                // myRef.child("cityForSearch").setValue(cityForSearch)
                                
                                cityRef.child("downloadURL").setValue(downloadURL)
                                cityRef.child("description").setValue(self.itemDescription.text!)
                                cityRef.child("timeStamp").setValue(timeStamp)
                                cityRef.child("uid").setValue(currUser!)
                                allRef.child("name").setValue(self.myEmail)
                                cityRef.child("lon").setValue(lon)
                                cityRef.child("lat").setValue(lat)
                                cityRef.child("locationName").setValue(locationName)
                                cityRef.child("city").setValue(city)
                                // cityRef.child("cityForSearch").setValue(cityForSearch)
                                
                            }
                            DispatchQueue.main.async {
                                
                                didUserJustPosted = true
                                
                                UserDefaults.standard.removeSuite(named: "lat")
                                UserDefaults.standard.removeSuite(named: "lon")
                                UserDefaults.standard.removeSuite(named: "title")
                                UserDefaults.standard.removeSuite(named: "city")
                                //let myCell = SecondPage()
                                //myCell.collectionView?.reloadData()
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
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
                let refCity = Database.database().reference().child("allPosts").child(foundOrLost).child(cityForEdit).child(postName)
                ref.removeValue()
                refCity.removeValue()
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
                                //let cityForSearch = city?.folding(options: .diacriticInsensitive, locale: .current).capitalized
                                var allRef = Database.database().reference().child("allPosts")
                                var cityRef = Database.database().reference().child("allPosts")//.child(self.cityForEdit).child(postName)
                                if self.mySwitch.isOn{
                                    allRef = Database.database().reference().child("allPosts").child("found").child(postName)
                                    cityRef = Database.database().reference().child("allPosts").child("found").child(self.cityForEdit).child(postName)
                                } else {
                                    allRef = Database.database().reference().child("allPosts").child("lost").child(postName)
                                    cityRef = Database.database().reference().child("allPosts").child("lost").child(self.cityForEdit).child(postName)
                                }
                                let myRef = Database.database().reference().child("users").child(currUser!).child("myPosts").child(postName)
                                
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
                                allRef.child("name").setValue(self.myEmail)
                                allRef.child("lon").setValue(lon)
                                allRef.child("lat").setValue(lat)
                                allRef.child("locationName").setValue(locationName)
                                allRef.child("city").setValue(city)
                                
                                
                                
                                myRef.child("timeStamp").setValue(timeStamp * -1)
                                myRef.child("downloadURL").setValue(downloadURL)
                                myRef.child("description").setValue(self.itemDescription.text!)
                                myRef.child("uid").setValue(currUser!)
                                myRef.child("name").setValue(self.myEmail)
                                myRef.child("locationName").setValue(locationName)
                                myRef.child("city").setValue(city)
                                
                                
                                cityRef.child("downloadURL").setValue(downloadURL)
                                cityRef.child("description").setValue(self.itemDescription.text!)
                                cityRef.child("timeStamp").setValue(timeStamp)
                                cityRef.child("uid").setValue(currUser!)
                                allRef.child("name").setValue(self.myEmail)
                                cityRef.child("lon").setValue(lon)
                                cityRef.child("lat").setValue(lat)
                                cityRef.child("locationName").setValue(locationName)
                                cityRef.child("city").setValue(city)
                                
                                
                            }
                            DispatchQueue.main.async {
                                
                                didUserJustPosted = true
                                
                                UserDefaults.standard.removeSuite(named: "lat")
                                UserDefaults.standard.removeSuite(named: "lon")
                                UserDefaults.standard.removeSuite(named: "title")
                                UserDefaults.standard.removeSuite(named: "city")
                                //let myCell = SecondPage()
                                //myCell.collectionView?.reloadData()
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
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
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 33.35).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(tempButtonWithImage)
        
        tempButtonWithImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempButtonWithImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 4 * UIScreen.main.bounds.height / 33.35).isActive = true
        tempButtonWithImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
        tempButtonWithImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3.2).isActive = true
        
        
        view.addSubview(openMapsButton)
        
        openMapsButton.topAnchor.constraint(equalTo: tempButtonWithImage.bottomAnchor, constant: 8).isActive = true
        openMapsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openMapsButton.widthAnchor.constraint(equalToConstant: 140 ).isActive = true
        openMapsButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        view.addSubview(info)
        
        info.leftAnchor.constraint(equalTo: openMapsButton.rightAnchor, constant: 12).isActive = true
        info.heightAnchor.constraint(equalToConstant: 20).isActive = true
        info.widthAnchor.constraint(equalToConstant: 20).isActive = true
        info.centerYAnchor.constraint(equalTo: openMapsButton.centerYAnchor).isActive = true
        
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

