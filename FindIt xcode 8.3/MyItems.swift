//
//  ViewController.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 12/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase



class MyItems: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView?
    var cellId = "CellId"
    var user = Userr()
    var scrollIndex = 0
    var allUsers = EveryUser()
    var cities = [String]()
    var locations = [String]()
    var date = [Double]()
    var emails = [String]()
    var descriptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Items"
        
        self.view.backgroundColor = .white
        self.title = "My Items"
        
        if user.downloadUrls.isEmpty{
            observeOneTime()
        }
        setupCollectionView()
        setNeedsStatusBarAppearanceUpdate()
        
        
    }
    
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(MyItemsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
          collectionView?.contentMode = .scaleAspectFill
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        //  collectionView?.isPagingEnabled = true
        view.addSubview(collectionView!)
        
       /*  collectionView?.translatesAutoresizingMaskIntoConstraints = false
         collectionView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
         collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
         collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        */
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView!)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView!)
        
    }
    
    
    
    func observeOneTime(){
        
        if Auth.auth().currentUser?.uid != nil{
            
            
            let ref =  Database.database().reference().child("allPosts")//.child(uid)
            
            ref.queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                self.user.descriptions.removeAll()
                self.user.downloadUrls.removeAll()
                
                guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
                for snap in snapshots {
                    
                    if Auth.auth().currentUser?.uid == snap.childSnapshot(forPath: "uid").value as? String{
                        
                        self.user.postName.append(snap.key)
                        
                        if let timePosted = snap.childSnapshot(forPath: "timeStamp").value as? Int {
                            self.user.timeStamp.append(timePosted)
                            self.user.dictionary["timeStamp"] = timePosted
                            self.date.append(Double(timePosted))
                            // print("timeposted ", timePosted)
                            
                        }
                        
                        if let description = snap.childSnapshot(forPath: "description").value as? String {
                            self.descriptions.append(description)
                        }

                        
                        if let snaap = snap.childSnapshot(forPath: "description").value as? String{
                            self.user.descriptions.append(snaap)
                            self.user.dictionary["description"] = snaap
                        }
                        if let snaaap = snap.childSnapshot(forPath: "downloadURL").value as? String {
                            self.user.downloadUrls.append(snaaap)
                            self.user.dictionary["downloadURL"] = snaaap
                        }
                        if let uid = snap.childSnapshot(forPath: "uid").value as? String {
                            self.user.uid.append(uid)
                            // self.allUsers.dictionary["downloadURL"] = snaaap
                        }
                        
                        if let city = snap.childSnapshot(forPath: "city").value as? String{
                            self.cities.append(city)
                        }
                        
                        if let location = snap.childSnapshot(forPath: "locationName").value as? String {
                            self.locations.append(location)
                        }
                    }
                }
                self.descriptions.reverse()
                self.user.postName.reverse()
                self.user.timeStamp.reverse()
                self.user.downloadUrls.reverse()
                self.user.descriptions.reverse()
                self.locations.reverse()
                self.cities.reverse()
                
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    // ref.removeAllObservers()
                })

               
            })
        }
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return user.descriptions.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
/*func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let text: String!
 
 if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MyItemsCell {
 cell.awakeFromNib()
 let profileImageURL = allUsers.downloadUrls[indexPath.row]
 cell.womanImage.loadImageUsingCacheWithUrlString(profileImageURL)
 cell.cityLabel.text = cities[indexPath.item]
 cell.locationLabel.text = locations[indexPath.item]
 let date = Date(timeIntervalSince1970:self.date[indexPath.item])
 cell.dateLabel.text = makeDate(date: date)//String(describing: Date(timeIntervalSince1970:date[indexPath.item]))
 
 let ref = Database.database().reference().child("users").child(allUsers.uid[indexPath.item])
 ref.observe(.value, with: { (snapshot) in
 // print("user snapshot ",snapshot)
 
 let dictionary = snapshot.value as! [String: Any]
 let name = dictionary["email"] as! String
 self.emails.append(name)
 
 cell.nameLabel.text = name
 
 
 }, withCancel: nil)
 //cell.womanImage.contentMode = .scaleToFill
 
 if isSearching {
 
 let imageIndex = findSame(a: allUsers.descriptions, b: filteredData)
 
 
 cell.awakeFromNib()
 text = filteredData[indexPath.row]
 
 let imageURL = allUsers.downloadUrls[imageIndex[indexPath.row]]
 //filteredImages
 cell.womanImage.loadImageUsingCacheWithUrlString(imageURL)
 //cell.womanImage.contentMode = .scaleToFill
 
 }  else {
 
 text = allUsers.descriptions[indexPath.row]
 }
 cell.congigureCell(text: text!)
 return cell
 } else {
 return UICollectionViewCell()
 }
 }
*/
    
    func makeDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }

 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyItemsCell
        cell.awakeFromNib()
        let profileImageURL = user.downloadUrls[indexPath.row]
        cell.womanImage.loadImageUsingCacheWithUrlString(profileImageURL)
        cell.womanImage.contentMode = .scaleAspectFit
        cell.cityLabel.text = cities[indexPath.item]
        cell.locationLabel.text = locations[indexPath.item]
        cell.infoLabel.text = descriptions[indexPath.item]
        let date = Date(timeIntervalSince1970:self.date[indexPath.item])
        cell.dateLabel.text = makeDate(date: date)//String(describing: Date(timeIntervalSince1970:date[indexPath.item]))
        
        cell.itemDescription.text = user.descriptions[indexPath.item]
 
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width , height: 466)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postInfo = MyPostInfo()
        let profileImageURL = user.downloadUrls[indexPath.item]
        postInfo.image.loadImageUsingCacheWithUrlString(profileImageURL)
        postInfo.image.contentMode = .scaleAspectFit
        //postInfo.descriptiontextField.text = allUsers.descriptions[indexPath.item]
        postInfo.postName = user.postName[indexPath.item]
        let currentCell = collectionView.cellForItem(at: indexPath) as! MyItemsCell
        postInfo.posterUid.text = currentCell.nameLabel.text!
        postInfo.dateLabel.text = currentCell.dateLabel.text!
        postInfo.locationLabel.text = currentCell.locationLabel.text!
        postInfo.cityLabel.text = currentCell.cityLabel.text!
        
        //postInfo.postName = user.postName[indexPath.item]
        postInfo.imageUrl = profileImageURL
        
               
        show(postInfo, sender: self)
    }
    
}






