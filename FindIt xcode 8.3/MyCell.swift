//
//  AllItemsCollectionViewCell.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 24/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase



class MyCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: ShowController!
    
    func show(){
        sshowController()
    }
    
    var isItFoundOrLost = [String]()
    
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
        //observeOneTime()
        //searchPosts()
        getMyPosts()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        //tableView.layoutIfNeeded()
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: cellId)
        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tableView.addSubview(refresh)
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        contentView.addConstraintsWithFormat(format: "V:|-50-[v0]-85-|", views: tableView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        
    }
    
    var lastKey: String? = nil
    
    var didUserClickedPost = false {
        didSet{
            if didUserClickedPost == true{
                //  refreshData()
                didUserClickedPost = false
            }
        }
    }
    
    lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        return refresh
    }()
    
    func refreshPosts(){
        a = 2
        i = 0
        self.postId.removeAll()
        getMyPosts()
    }
    
    func getMyPosts(){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!).child("myPosts")
        ref.queryOrdered(byChild: "timeStamp").queryLimited(toFirst: UInt(a)).observe(.value, with: { (snapshot) in
            self.allUsers.descriptions.removeAll()
            self.allUsers.downloadUrls.removeAll()
            self.allUsers.uid.removeAll()
            self.cities.removeAll()
            self.locations.removeAll()
            self.date.removeAll()
            self.postId.removeAll()
            self.emails.removeAll()
            self.isItFoundOrLost.removeAll()
            
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for snap in snapshots {
                
                
                self.postId.append(snap.key)
                self.allUsers.postName.append(snap.key)
                
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
                
                if let email = snap.childSnapshot(forPath: "name").value as? String{ // cia istikro vardas!
                    self.emails.append(email)
                }
                
                if let foundLost = snap.childSnapshot(forPath: "foundOrLost").value as? String {
                    self.isItFoundOrLost.append(foundLost)
                }
                
               
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refresh.endRefreshing()
                self.i += 2
                
            }
            if self.postId.count == 0 {
                self.showNoResults()
                self.refresh.endRefreshing()
            } else {
                self.noResults.removeFromSuperview()
            }
            
        })
    }
    
    //    var a = 5
    //    func myPosts(){
    //    //cia viskas atvirksciai, nes databse timeStamp = date * -1
    //        let uid = Auth.auth().currentUser?.uid
    //        let ref = Database.database().reference().child("users").child(uid!).child("myPosts")
    //        ref.queryOrdered(byChild: "timeStamp").queryLimited(toFirst: UInt(a)).observeSingleEvent(of: .value, with: { (snapshot) in
    //            // print(snapshot)
    //            self.allUsers.descriptions.removeAll()
    //            self.allUsers.downloadUrls.removeAll()
    //            self.allUsers.uid.removeAll()
    //            self.cities.removeAll()
    //            self.locations.removeAll()
    //            self.date.removeAll()
    //            self.postId.removeAll()
    //            self.emails.removeAll()
    //            self.isItFoundOrLost.removeAll()
    //            print("ZIURIU")
    //
    //            var i = -1
    //            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
    //            for snap in snapshots{
    //                self.postId.append(snap.key)//insert(snap.key, at: 0)
    //                self.allUsers.postName.append(snap.key)//insert(snap.key, at: 0)
    //                //print("post Id ", self.postId.count)
    //                i += 1
    //                print(snap.key)
    //                if let lostFound = snap.childSnapshot(forPath: "foundOrLost").value as? String{
    //
    //                    self.isItFoundOrLost.append(lostFound)//insert(lostFound, at: 0)
    //
    //                    self.foundMyPosts(foundLost: lostFound, postId: snap.key,i: i)
    //                }
    //                if let time = snap.childSnapshot(forPath: "timeStamp").value as? Double{
    //                    print(time)
    //                }
    //                DispatchQueue.main.async {
    //                    ref.removeAllObservers()
    //                }
    //            }
    //
    //            if self.postId.count == 0 {
    //                self.showNoResults()
    //                self.refresh.endRefreshing()
    //            } else {
    //                self.noResults.removeFromSuperview()
    //            }
    //        })
    //    }
    //
    //    func foundMyPosts(foundLost: String, postId: String, i: Int){
    //        //let uid = Auth.auth().currentUser?.uid
    //        let ref = Database.database().reference().child("allPosts").child(foundLost).child(postId)
    //
    //        ref.observeSingleEvent(of: .value, with: { (snapshot) in
    //            //print(snapshot.key)
    //            if snapshot.exists(){
    //                guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
    //                for snap in snapshots{
    //                    if let timePosted = snap.childSnapshot(forPath: "timeStamp").value as? Int {
    //                    print(timePosted)
    //                    }
    //                }
    //                let dict = snapshot.value as? [String: Any]
    //
    //                if let description = dict?["description"] as? String {
    //                    //print(description)
    //                    self.allUsers.descriptions.append(description)//.insert(description, at: 0)
    //                }
    //
    //
    //                if let downloadUrl = dict?["downloadURL"] as? String {
    //                    self.allUsers.downloadUrls.append(downloadUrl)//insert(downloadUrl, at: 0)
    //                }
    //
    //                if let city = dict?["city"] as? String {
    //                    self.cities.append(city)//insert(city, at: 0)
    //                }
    //
    //                if let location = dict?["locationName"] as? String {
    //                    self.locations.append(location)//insert(location, at: 0)
    //                }
    //
    //                if let date = dict?["timeStamp"] as? Double {
    //                    self.date.append(date)//insert(date, at: 0)
    //                    //print(date)
    //                }
    //
    //                if let name = dict?["name"] as? String {
    //                    self.emails.append(name)//insert(name, at: 0)
    //                }
    //
    //                if let uid = dict?["uid"] as? String {
    //                    self.allUsers.uid.append(uid)//insert(uid, at: 0)
    //                }
    ////                self.allUsers.descriptions.reverse()
    ////                self.allUsers.downloadUrls.reverse()
    ////                self.allUsers.uid.reverse()
    ////                self.cities.reverse()
    ////                self.locations.reverse()
    ////                self.date.reverse()
    ////                self.postId.reverse()
    ////                self.emails.reverse()
    ////                self.isItFoundOrLost.reverse()
    //                DispatchQueue.main.async(execute: {
    //
    //                    self.tableView.reloadData()
    //                    self.refresh.endRefreshing()
    //                    ref.removeAllObservers()
    //
    //                })
    //
    //            }//if snapshot exists
    ////            DispatchQueue.main.async {
    ////                self.tableView.reloadData()
    ////            }
    ////
    //        })
    //
    //
    //
    //    }
    //
    //
    
    
    //    func searchPosts(){
    //
    //        let uid = Auth.auth().currentUser?.uid
    //        let ref = Database.database().reference().child("allPosts").child("lost")
    //
    //        ref.queryOrdered(byChild: "uid").queryStarting(atValue: uid).queryEnding(atValue: uid!+"\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
    //
    //            self.allUsers.descriptions.removeAll()
    //            self.allUsers.downloadUrls.removeAll()
    //            self.allUsers.uid.removeAll()
    //            self.cities.removeAll()
    //            self.locations.removeAll()
    //            self.date.removeAll()
    //            self.postId.removeAll()
    //            self.emails.removeAll()
    //            self.isItFoundOrLost.removeAll()
    //
    //            if snapshot.exists(){
    //
    //
    //                guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
    //                for snap in snapshots {
    //                    self.isItFoundOrLost.append("lost")
    //                    self.postId.append(snap.key)
    //                    self.allUsers.postName.append(snap.key)
    //
    //                    if let timePosted = snap.childSnapshot(forPath: "timeStamp").value as? Int {
    //                        self.allUsers.timeStamp.append(timePosted)
    //                        self.allUsers.dictionary["timeStamp"] = timePosted
    //                        self.date.append(Double(timePosted))
    //
    //
    //                    }
    //
    //                    if let snaap = snap.childSnapshot(forPath: "description").value as? String{
    //                        self.allUsers.descriptions.append(snaap)
    //                        self.allUsers.dictionary["description"] = snaap
    //                    }
    //                    if let snaaap = snap.childSnapshot(forPath: "downloadURL").value as? String {
    //                        self.allUsers.downloadUrls.append(snaaap)
    //                        self.allUsers.dictionary["downloadURL"] = snaaap
    //                    }
    //                    if let uid = snap.childSnapshot(forPath: "uid").value as? String {
    //                        self.allUsers.uid.append(uid)
    //                        // self.allUsers.dictionary["downloadURL"] = snaaap
    //                    }
    //
    //                    if let city = snap.childSnapshot(forPath: "city").value as? String{
    //                        self.cities.append(city)
    //                    }
    //
    //                    if let location = snap.childSnapshot(forPath: "locationName").value as? String {
    //                        self.locations.append(location)
    //                    }
    //
    //                    if let email = snap.childSnapshot(forPath: "name").value as? String{// cia vardas!!!
    //                        self.emails.append(email)
    //                    }
    //
    //                }
    //
    //
    //
    //
    //                DispatchQueue.main.async(execute: {
    //                    // self.sortPosts(timee: self.date)
    //                    self.getFoundItems()
    //                    ref.removeAllObservers()
    //                })
    //            } else {
    //                self.getFoundItems()
    //            }
    //
    //        })
    //
    //    }
    
    var noResults: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You haven't posted yet"
        label.font = UIFont(name: "Avenir Next", size: 16)
        return label
    }()
    
    //    func getFoundItems(){
    //        let uid = Auth.auth().currentUser?.uid
    //        let ref = Database.database().reference().child("allPosts").child("found")
    //        ref.queryOrdered(byChild: "uid").queryStarting(atValue: uid).queryEnding(atValue: uid!+"\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
    //            /* self.allUsers.descriptions.removeAll()
    //             self.allUsers.downloadUrls.removeAll()
    //             self.allUsers.uid.removeAll()
    //             self.cities.removeAll()
    //             self.locations.removeAll()
    //             self.date.removeAll()
    //             self.postId.removeAll()
    //             self.emails.removeAll()*/
    //
    //            if snapshot.exists(){
    //                guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
    //                for snap in snapshots {
    //                    self.isItFoundOrLost.append("found")
    //                    self.postId.append(snap.key)
    //                    self.allUsers.postName.append(snap.key)
    //
    //                    if let timePosted = snap.childSnapshot(forPath: "timeStamp").value as? Int {
    //                        self.allUsers.timeStamp.append(timePosted)
    //                        self.allUsers.dictionary["timeStamp"] = timePosted
    //                        self.date.append(Double(timePosted))
    //
    //
    //                    }
    //
    //                    if let snaap = snap.childSnapshot(forPath: "description").value as? String{
    //                        self.allUsers.descriptions.append(snaap)
    //                        self.allUsers.dictionary["description"] = snaap
    //                    }
    //                    if let snaaap = snap.childSnapshot(forPath: "downloadURL").value as? String {
    //                        self.allUsers.downloadUrls.append(snaaap)
    //                        self.allUsers.dictionary["downloadURL"] = snaaap
    //                    }
    //                    if let uid = snap.childSnapshot(forPath: "uid").value as? String {
    //                        self.allUsers.uid.append(uid)
    //                        // self.allUsers.dictionary["downloadURL"] = snaaap
    //                    }
    //
    //                    if let city = snap.childSnapshot(forPath: "city").value as? String{
    //                        self.cities.append(city)
    //                    }
    //
    //                    if let location = snap.childSnapshot(forPath: "locationName").value as? String {
    //                        self.locations.append(location)
    //                    }
    //
    //                    if let email = snap.childSnapshot(forPath: "name").value as? String{// cia vardas!!!
    //                        self.emails.append(email)
    //                    }
    //
    //                }
    //
    //
    //
    //
    //                DispatchQueue.main.async(execute: {
    //                    self.sortPosts(timee: self.date)
    //                    ref.removeAllObservers()
    //                })
    //            }// if snapshot exists
    //
    //            else {
    //
    //                if self.allUsers.descriptions.count == 0 {
    //                    self.showNoResults()
    //                }
    //
    //
    //                self.sortPosts(timee: self.date)
    //            }
    //        })
    //    }
    
    func showNoResults(){
        contentView.addSubview(self.noResults)
        noResults.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        noResults.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        noResults.heightAnchor.constraint(equalToConstant: 40).isActive = true
        noResults.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    //    func sortPosts(timee: [Double]){
    //        var time = timee
    //        if time.count > 1{
    //            var i = 0
    //            while i < time.count - 1{
    //                var j = i
    //                while j < time.count {
    //                    if time[j] < time[i]{ // date[0] > date[1]
    //                        time.insert(time[j], at: i)
    //                        time.remove(at: j + 1)
    //
    //                        date.insert(date[j], at: i)
    //                        date.remove(at: j + 1)
    //
    //
    //
    //                        isItFoundOrLost.insert(isItFoundOrLost[j], at: i)
    //                        isItFoundOrLost.remove(at: j + 1)
    //
    //
    //                        emails.insert(emails[j], at: i)
    //                        emails.remove(at: j + 1)
    //
    //                        cities.insert(cities[j], at: i)
    //                        cities.remove(at: j + 1)
    //
    //                        locations.insert(locations[j], at: i)
    //                        locations.remove(at: j + 1)
    //
    //                        postId.insert(postId[j], at: i)
    //                        postId.remove(at: j + 1)
    //
    //                        allUsers.uid.insert(allUsers.uid[j], at: i)
    //                        allUsers.uid.remove(at: j + 1)
    //
    //                        allUsers.timeStamp.insert(allUsers.timeStamp[j], at: i)
    //                        allUsers.timeStamp.remove(at: j + 1)
    //
    //                        allUsers.postName.insert(allUsers.postName[j], at: i)
    //                        allUsers.postName.remove(at: j + 1)
    //
    //                        allUsers.downloadUrls.insert(allUsers.downloadUrls[j], at: i)
    //                        allUsers.downloadUrls.remove(at: j + 1)
    //
    //                        allUsers.descriptions.insert(allUsers.descriptions[j], at: i)
    //                        allUsers.descriptions.remove(at: j + 1)
    //                    }
    //                    j += 1
    //                }
    //                i += 1
    //            }
    //        }
    //        self.date.reverse()
    //        self.emails.reverse()
    //        self.allUsers.uid.reverse()
    //        self.allUsers.postName.reverse()
    //        self.allUsers.timeStamp.reverse()
    //        self.allUsers.downloadUrls.reverse()
    //        self.allUsers.descriptions.reverse()
    //        self.cities.reverse()
    //        self.locations.reverse()
    //        self.isItFoundOrLost.reverse()
    //        self.postId.reverse()
    //
    //        if allUsers.descriptions.count > 0{
    //            noResults.removeFromSuperview()
    //        }
    //        tableView.reloadData()
    //        self.refresh.endRefreshing()
    //    }
    //
    /* func observeOneTime(){
     
     if Auth.auth().currentUser?.uid != nil{
     
     
     let ref =  Database.database().reference().child("allPosts").child("found")//.child(uid)
     
     ref.queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value, with: { (snapshot) in
     
     
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
     
     if let email = snap.childSnapshot(forPath: "email").value as? String{
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
     
     })
     })
     }
     }
     */
    
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
        return 161//UIScreen.main.bounds.height //- 40
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
        let date = Date(timeIntervalSince1970:self.date[indexPath.item] * -1)
        cell.dateLabel.text = makeDate(date: date)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.nameLabel.text = emails[indexPath.row]
        cell.dateLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.locationLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.infoLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.cityLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        
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
        
        descriptiontextField.text = currentCell.infoLabel.text
        toIdd = allUsers.uid[indexPath.row]
        imageUrl = profileImageURL
        
        foundOrLost = isItFoundOrLost[indexPath.row]
        
        show()
    }
    var i = 0
    var a  = 2
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let lasItem = allUsers.descriptions.count - 1
            
            if lasItem > 0 {
                if indexPath.row == lasItem{
                    
                    if i <= postId.count{
                        
                        a += 2
                        //addMoreRows()
                        getMyPosts()
                    }
                    // handle your logic here to get more items, add it to dataSource and reload tableview
                }
            }
    
        }
    
    
}
