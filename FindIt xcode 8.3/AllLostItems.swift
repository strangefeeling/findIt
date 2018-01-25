//
//  AllItemsCollectionViewCell.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 24/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase




class AllLostItems: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: ShowController!
    
    func show(){
        sshowController()
    }
    
    let cellId = "cellid"
    let allUsers = EveryUser()
    let tableView = UITableView()
    var postId = [String]()
    var messagesInPost = [String]()
    var allUids = [String]()
    var cities = [String]()
    var locations = [String]()
    var date = [Double]()
    var emails = [String]()
    
    override func awakeFromNib() {
        observeOneTime()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.layoutIfNeeded()
        tableView.separatorStyle = .none
        
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: cellId)
        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tableView.addSubview(refresh)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        contentView.addConstraintsWithFormat(format: "V:|-50-[v0]-85-|", views: tableView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func refreshPosts(){
        a = 5
        i = 0
        self.howManySnaps.removeAll()
        observeOneTime()
    }
    
    lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        return refresh
    }()
    
    func observeOneTime(){
        
        if Auth.auth().currentUser?.uid != nil{
            
            
            let ref =  Database.database().reference().child("allPosts").child("lost")//.child(uid)
            
            ref.queryLimited(toLast: UInt(a)).queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value, with: { (snapshot) in
                
                //   self.a = 5
                //   self.i = 5
                
                self.howManySnaps.removeAll()
                self.allUsers.descriptions.removeAll()
                self.allUsers.downloadUrls.removeAll()
                self.allUsers.uid.removeAll()
                self.cities.removeAll()
                self.locations.removeAll()
                self.date.removeAll()
                self.postId.removeAll()
                self.emails.removeAll()
                
                guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
                for snap in snapshots {
                    
                    
                    self.postId.append(snap.key)
                    self.allUsers.postName.append(snap.key)
                    self.howManySnaps.append(snap.key)
                    if let timePosted = snap.childSnapshot(forPath: "timeStamp").value as? Int {
                        self.allUsers.timeStamp.append(timePosted)
                        self.allUsers.dictionary["timeStamp"] = timePosted
                        self.date.append(Double(timePosted))
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
                    
                    if let email = snap.childSnapshot(forPath: "name").value as? String{// cia vardas!!!
                        self.emails.append(email)
                    }
                    
                }
                self.date.reverse()
                self.emails.reverse()
                self.allUsers.uid.reverse()
                self.allUsers.postName.reverse()
                self.allUsers.timeStamp.reverse()
                self.allUsers.downloadUrls.reverse()
                self.allUsers.descriptions.reverse()
                self.cities.reverse()
                self.locations.reverse()
                self.postId.reverse()
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.i += 5
                    
                    ref.removeAllObservers()
                    self.refresh.endRefreshing()
                    
                })
            })
        }
    }
    
    
    /*  func getEmails(){
     let ref = Database.database().reference().child("users").child(emails[index])
     ref.observe(.value, with: { (snapshot) in
     
     
     
     let dictionary = snapshot.value as! [String: Any]
     let name = dictionary["email"] as! String
     self.emails.append(name)
     
     
     DispatchQueue.main.async {
     self.tableView.reloadData()
     }
     
     
     }, withCancel: nil)
     
     }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100//UIScreen.main.bounds.height
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allUsers.descriptions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as!
        AllItemsTableViewCell
        cell.awakeFromNib()
        cell.infoLabel.text = allUsers.descriptions[indexPath.row]
        cell.cityLabel.text = cities[indexPath.row]
        let profileImageURL = allUsers.downloadUrls[indexPath.row]
        cell.womanImage.loadImageUsingCacheWithUrlString(profileImageURL)
        cell.locationLabel.text = locations[indexPath.item]
        let date = Date(timeIntervalSince1970:self.date[indexPath.item])
        cell.nameLabel.text = emails[indexPath.row]
        cell.dateLabel.text = makeDate(date: date)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.dateLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.locationLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.infoLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.cityLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)

        //cell.nameLabel.text = emails[indexPath.row]
        
        
        
        return cell
        
    }
    
    func sshowController() {
        self.delegate.showController()
    }
    
    func makeDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // let postInfo = PostInfo()
        let profileImageURL = allUsers.downloadUrls[indexPath.item]
        
        image.loadImageUsingCacheWithUrlString(profileImageURL)
        image.contentMode = .scaleAspectFit
        //postInfo.descriptiontextField.text = allUsers.descriptions[indexPath.item]
        postName = allUsers.postName[indexPath.item]
        let currentCell = tableView.cellForRow(at: indexPath) as! AllItemsTableViewCell
        posterUid.text = currentCell.nameLabel.text
        dateLabel.text = currentCell.dateLabel.text!
        locationLabel.text = currentCell.locationLabel.text!
        cityLabel.text = currentCell.cityLabel.text!
        postName = postId[indexPath.item]
        foundOrLost = "lost"
        toIdd = allUsers.uid[indexPath.row]
        descriptiontextField.text = currentCell.infoLabel.text
        imageUrl = profileImageURL
        
        show()
    }
    
    var i = 0
    
    var howManySnaps = [String]()
    var a = 5
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lasItem = allUsers.descriptions.count - 3
        print("count", howManySnaps.count, i, a)
        if indexPath.row == lasItem{
            
            if i <= howManySnaps.count{
                print("load more ", i, a)
                a += 5
                //addMoreRows()
                observeOneTime()
            }
            // handle your logic here to get more items, add it to dataSource and reload tableview
        }
    }

}
