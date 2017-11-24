//
//  PostItemViewController.swift
//  ex
//
//  Created by Rytis on 05/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

class AddItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var imageToPost: UIImage?
    let allItems = AllItems()
    let backButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            self.view.frame.origin.y -= keyboardHeight
            
          //  self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - keyboardHeight)
            
        }
    }
    
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += keyboardHeight
        UIView.animate(withDuration: 0.5) {
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        
        keyboardHeight = 0
        
    }

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
        pb.addTarget(self, action: #selector(postToServer), for: .touchUpInside)
        pb.tintColor = UIColor.white
        pb.translatesAutoresizingMaskIntoConstraints = false
        
        return pb
    }()
    
    func toMaps(){
        let map = MapController()
        dismissKeyboard()
        show(map, sender: self)
      //  present(map, animated: true, completion: nil)
    }
    
    @objc func postToServer(){
        if imageToPost != nil && itemDescription.text != ""{
            print("Posted")
            let imageName = NSUUID().uuidString
            let postName = NSUUID().uuidString
            let imagesFolder = Storage.storage().reference().child("images")
            
            if let imageData = UIImageJPEGRepresentation(imageToPost!, 0.2){
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
                            let allRef = Database.database().reference().child("allPosts").child(postName)
                            //allRef.setValue(currUser!)
                            /*  ref.child("downloadURL").setValue(downloadURL)
                             ref.child("description").setValue(self.itemDescription.text!)
                             ref.child("timeStamp").setValue(timeStamp)*/
                            // allRef.child(currUser!).setValue(currUser!)
                            allRef.child("downloadURL").setValue(downloadURL)
                            allRef.child("description").setValue(self.itemDescription.text!)
                            allRef.child("timeStamp").setValue(timeStamp)
                            allRef.child("uid").setValue(currUser!)
                            allRef.child("lon").setValue(lon)
                            allRef.child("lat").setValue(lat)
                            allRef.child("locationName").setValue(locationName)
                            allRef.child("city").setValue(city)
                            
                        }
                        
                    }
                    DispatchQueue.main.async {
                        UserDefaults.standard.removeSuite(named: "lat")
                        UserDefaults.standard.removeSuite(named: "lon")
                        UserDefaults.standard.removeSuite(named: "title")
                        UserDefaults.standard.removeSuite(named: "city")
                        self.allItems.collectionView?.reloadData()
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = myColor
        //view.addSubview(backButton)
        view.addSubview(tempButtonWithImage)
        view.addSubview(openMapsButton)
        view.addSubview(itemDescription)
        view.addSubview(postButton)
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupView()
        
    }
    
    func setupView(){
        
        tempButtonWithImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempButtonWithImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        tempButtonWithImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
        tempButtonWithImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2 - 90).isActive = true
        
       /* backButton.setTitle("Back", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 100).isActive = true*/
        
        openMapsButton.topAnchor.constraint(equalTo: tempButtonWithImage.bottomAnchor, constant: 8).isActive = true
        openMapsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openMapsButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        openMapsButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        itemDescription.topAnchor.constraint(equalTo: openMapsButton.bottomAnchor, constant: 20).isActive = true
        itemDescription.leftAnchor.constraint(equalTo: tempButtonWithImage.leftAnchor, constant: 0).isActive = true
        itemDescription.widthAnchor.constraint(equalTo: tempButtonWithImage.widthAnchor).isActive = true
        itemDescription.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2 - 250).isActive = true
        
        postButton.topAnchor.constraint(equalTo: itemDescription.bottomAnchor, constant: 10).isActive = true
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
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

