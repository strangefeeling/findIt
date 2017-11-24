//
//  AllItems.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 12/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase
//var previousIndexPath = [IndexPath]()
class AllItems: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var h = 0
    var collectionView: UICollectionView?
    let tableView = UITableView()
    var allUsers = EveryUser()
    let chat = Chat()
    let cellId = "anotherCell"
    let searchBar = UISearchBar()
    var filteredData = [String]()
    var filteredData2 = ["description": String(),"downloadUrls": String(), "timeStamp": Int()] as [String : Any]
    var filteredImages = [String]()
    var isSearching = false
    let searchController = UISearchController(searchResultsController: nil)
    var postId = [String]()
    var messagesInPost = [String]()
    var allUids = [String]()
    var cities = [String]()
    var locations = [String]()
    var date = [Double]()
    var emails = [String]()
    
    var womanImage: UIImageView!
    let itemDescription: UITextView = {
        var dc = UITextView()
        dc.text = "Whaddup"
        dc.font = UIFont(name: "Avenir Book", size: 22)
        dc.textAlignment = .center
        
        return dc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        //getUserUids()
        DispatchQueue.main.async {
            
        }
        if allUsers.downloadUrls.isEmpty{
            observeOneTime()
        }
        
        filteredData2 = allUsers.dictionary
        setupCollectionView()
        //setupaSearchBar()
        
        
    }
    
    
    
    func setupaSearchBar(){
        searchBar.delegate = self
        searchBar.barTintColor = myColor
        searchBar.returnKeyType = UIReturnKeyType.done
        
        // searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = searchBar.barTintColor?.cgColor
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    var i = 0
    var uidsCount = 0
    
    /*  func getUserUids(){
     
     i = 0
     uidsCount = 0
     if Auth.auth().currentUser != nil{
     let ref =  Database.database().reference().child("allPosts")
     ref.observe(.value, with: { (snapshot) in
     // print("uids ", snapshot.key)
     guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
     //self.allUsers.descriptions.removeAll()
     //self.allUsers.downloadUrls.removeAll()
     for snap in snapshots{
     self.allUids.append(snap.key)
     self.i += 1
     // print("uids ", self.allUids)
     }
     DispatchQueue.main.async {
     if self.allUsers.downloadUrls.isEmpty{
     self.observeOneTime()
     }
     }
     }, withCancel: nil)
     
     }
     }*/
    
    func observeOneTime(){
        
        if Auth.auth().currentUser?.uid != nil{
            
            
            let ref =  Database.database().reference().child("allPosts")//.child(uid)
            
            ref.queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                self.allUsers.descriptions.removeAll()
                self.allUsers.downloadUrls.removeAll()
                self.allUsers.uid.removeAll()
                self.cities.removeAll()
                self.locations.removeAll()
                self.date.removeAll()
                self.postId.removeAll()
                
                guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
                for snap in snapshots {
                    
                    
                    self.postId.append(snap.key)
                    self.allUsers.postName.append(snap.key)
                    
                    if let timePosted = snap.childSnapshot(forPath: "timeStamp").value as? Int {
                        self.allUsers.timeStamp.append(timePosted)
                        self.allUsers.dictionary["timeStamp"] = timePosted
                        self.date.append(Double(timePosted))
                        // print("timeposted ", timePosted)
                        
                    }
                    
                    if let snaap = snap.childSnapshot(forPath: "description").value as? String{
                        self.allUsers.descriptions.append(snaap)
                        self.allUsers.dictionary["description"] = snaap
                    }
                    if let snaaap = snap.childSnapshot(forPath: "downloadURL").value as? String {
                        self.allUsers.downloadUrls.append(snaaap)
                        self.allUsers.dictionary["downloadURL"] = snaaap
                    }
                    if let uid = snap.childSnapshot(forPath: "uid").value as? String {
                        self.allUsers.uid.append(uid)
                        // self.allUsers.dictionary["downloadURL"] = snaaap
                    }
                    
                    if let city = snap.childSnapshot(forPath: "city").value as? String{
                       self.cities.append(city)
                    }
                    
                    if let location = snap.childSnapshot(forPath: "locationName").value as? String {
                        self.locations.append(location)
                    }
                    
                }
                self.date.reverse()
                self.allUsers.uid.reverse()
                self.allUsers.postName.reverse()
                self.allUsers.timeStamp.reverse()
                self.allUsers.downloadUrls.reverse()
                self.allUsers.descriptions.reverse()
                self.cities.reverse()
                self.locations.reverse()
                self.postId.reverse()
                
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    // ref.removeAllObservers()
                })
            })
        }
        
        
        
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(MyItemsCell.self, forCellWithReuseIdentifier: cellId)
        //    collectionView?.register(SecondPageCollectionViewCell.self, forCellWithReuseIdentifier: secondCellIdentifier)
        //    collectionView?.register(MyFirstCell.self, forCellWithReuseIdentifier: "LOL")
        
        collectionView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.contentMode = .scaleAspectFill
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        //  collectionView?.isPagingEnabled = true
        view.addSubview(collectionView!)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView!)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView!)
        
    }
    
    func findSame(a: [String],b:[String]) -> [Int]{
        var indeksai = [Int]()
        var sameWords = [String]()
        for item in a{
            for secondItem in b{
                if item == secondItem{
                    indeksai.append(a.index(of: secondItem)!)
                }
            }
        }
        var i = 0
        while  i < indeksai.count{
            sameWords.append(a[indeksai[i]])
            i += 1
        }
        return indeksai
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }
        return allUsers.descriptions.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func makeDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width , height: 466)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // previousIndexPath.append(indexPath)
      /*  if allUsers.uid[indexPath.item] == Auth.auth().currentUser?.uid{
            let edditPost = EdditPost()
            let profileImageURL = allUsers.downloadUrls[indexPath.item]
            edditPost.womanImage.loadImageUsingCacheWithUrlString(profileImageURL)
            edditPost.womanImage.contentMode = .scaleAspectFit
            edditPost.itemDescription.text = allUsers.descriptions[indexPath.item]
            edditPost.postName = allUsers.postName[indexPath.item]
            // let tabBarController = TabBarController()
            edditPost.selectedPost = indexPath.item
            
            show(edditPost, sender: nil)
        } else {*/
            let postInfo = PostInfo()
            let profileImageURL = allUsers.downloadUrls[indexPath.item]
            postInfo.image.loadImageUsingCacheWithUrlString(profileImageURL)
            postInfo.image.contentMode = .scaleAspectFit
            //postInfo.descriptiontextField.text = allUsers.descriptions[indexPath.item]
            postInfo.postName = allUsers.postName[indexPath.item]
            let currentCell = collectionView.cellForItem(at: indexPath) as! MyItemsCell
            postInfo.posterUid.text = currentCell.nameLabel.text!
            postInfo.dateLabel.text = currentCell.dateLabel.text!
            postInfo.locationLabel.text = currentCell.locationLabel.text!
            postInfo.cityLabel.text = currentCell.cityLabel.text!
            postInfo.postName = postId[indexPath.item]
            postInfo.imageUrl = profileImageURL
            
            UserDefaults.standard.set(allUsers.descriptions[indexPath.item], forKey: "descriptiontextField")
            UserDefaults.standard.set(currentCell.nameLabel.text!, forKey: "nameLabel")
            UserDefaults.standard.set(currentCell.dateLabel.text!, forKey: "dateLabel")
            UserDefaults.standard.set(currentCell.locationLabel.text!, forKey: "locationLabel")
            UserDefaults.standard.set(currentCell.cityLabel.text!, forKey: "cityLabel")
            
            show(postInfo, sender: self)
       // }
        
        
    }
    
  
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            collectionView?.reloadData()
        } else {
            isSearching = true
            filteredData = allUsers.descriptions.filter({(text: String) -> Bool in
                return text.lowercased().contains(searchBar.text!.lowercased())
            })
            collectionView?.reloadData()
            
        }
        
    }
    
}
