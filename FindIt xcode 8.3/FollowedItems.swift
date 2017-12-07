//
//  FollowedItems.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 05/12/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

class FollowedItems: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var commentedPosts = [String]()
    
    var allUsers = EveryUser()
    
    var tableView = UITableView()
    
    var delegate: ShowController!
    
    let cellId = "cellId"
    
    var postId = [String]()
    
    func show(){
        sshowController()
    }
    
    func sshowController() {
        self.delegate.showController()
    }
    
    override func awakeFromNib() {
        observeOneTime()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        contentView.addSubview(tableView)
        tableView.addSubview(refresh)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50).isActive = true
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(observeOneTime), for: .valueChanged)
        return refresh
    }()
    
    func observeOneTime(){
        let ref = Database.database().reference().child("allPosts").child("comments")
        ref.queryOrdered(byChild: "timeStamp").observe( .childAdded, with: { (snapshot) in
            let dict = snapshot.value as! [String: Any]
            
           // let comment = dict["comment"] as! String
            //print(dict)
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }

            for snap in snapshots{
                let dict = snap.value as! [String: Any]
                
                if let uid = snap.childSnapshot(forPath: "uid").value as? String{
                    
                    if uid == Auth.auth().currentUser?.uid{
                        if self.commentedPosts.contains(snapshot.key) == false {
                            self.commentedPosts.append(snapshot.key)
                            
                            self.getFollowedPosts(post: snapshot.key)
                        } else {
                            self.refresh.endRefreshing()
                        }
                        //print(snapshot.key)
                    }
                }
                
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                //print(self.commentedPosts)
                
            }
            //ref.removeAllObservers()
        }, withCancel: nil)
    }
    
    func getFollowedPosts(post: String){
        let foundRef = Database.database().reference().child("allPosts")
       
        self.allUsers.date.removeAll()
        self.allUsers.email.removeAll()
        self.allUsers.uid.removeAll()
        self.allUsers.postName.removeAll()
        self.allUsers.timeStamp.removeAll()
        self.allUsers.downloadUrls.removeAll()
        self.allUsers.descriptions.removeAll()
        self.allUsers.city.removeAll()
        self.allUsers.location.removeAll()
        self.postId.removeAll()
        
            foundRef.child("found").child(post).observe(.value, with: { (snapshot) in
                let dict = snapshot.value as? [String: Any]
                if snapshot.exists(){
                    
                    self.postId.append(snapshot.key)
                    
                    let date = dict?["timeStamp"] as! Double
                    self.allUsers.date.append(date)
                    
                    let downloadUrl = dict?["downloadURL"] as! String
                    self.allUsers.downloadUrls.append(downloadUrl)
                    
                    let location = dict?["locationName"] as! String
                    self.allUsers.location.append(location)
                    
                    let description = dict?["description"] as! String
                    self.allUsers.descriptions.append(description)
                    
                    let city = dict?["city"] as! String
                    self.allUsers.city.append(city)
                    
                    let uid = dict?["uid"] as! String
                    self.allUsers.uid.append(uid)
                    
                    let email = dict?["email"] as! String
                    self.allUsers.email.append(email)
                    
                    DispatchQueue.main.async {
                        //self.tableView.reloadData()
                        print("as radau lost")
                        self.getLostFollowed(post: post)
                        // print("found ",snapshot.key)
                    }
                   
                }
                else{
                    print("as neradau lost")
                    self.tableView.reloadData()
                    self.getLostFollowed(post: post)
                }
                
            })//cia foundRef snapshot
        
        
        
        
        
    }
    
    func getLostFollowed(post: String){
        let lostRef = Database.database().reference().child("allPosts")
        lostRef.child("lost").child(post).observe(.value, with: { (snapshot) in
            let dict = snapshot.value as? [String: Any]
            if snapshot.exists(){
                
                self.postId.append(snapshot.key)
                
                let date = dict?["timeStamp"] as! Double
                self.allUsers.date.append(date)
                
                let downloadUrl = dict?["downloadURL"] as! String
                self.allUsers.downloadUrls.append(downloadUrl)
                
                let location = dict?["locationName"] as! String
                self.allUsers.location.append(location)
                
                let description = dict?["description"] as! String
                self.allUsers.descriptions.append(description)
                
                let city = dict?["city"] as! String
                self.allUsers.city.append(city)
                
                let uid = dict?["uid"] as! String
                self.allUsers.uid.append(uid)
                
                let email = dict?["email"] as! String
                self.allUsers.email.append(email)
               
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.sortPosts(timee: self.allUsers.date)
                    //   print("lost  ",snapshot.key)
                }
            } else{
                self.tableView.reloadData()
                self.sortPosts(timee: self.allUsers.date)
            }
            
        })//cia lostRef

    }

    
    func sortPosts(timee: [Double]){
        var time = timee
        if time.count > 1{
            var i = 0
            while i < time.count - 1{
                var j = i
                while j < time.count {
                    if time[j] < time[i]{ // date[0] > date[1]
                        time.insert(time[j], at: i)
                        time.remove(at: j + 1)
                        
                        allUsers.date.insert(allUsers.date[j], at: i)
                        allUsers.date.remove(at: j + 1)
                        
                        allUsers.email.insert(allUsers.email[j], at: i)
                        allUsers.email.remove(at: j + 1)
                        
                        allUsers.city.insert(allUsers.city[j], at: i)
                        allUsers.city.remove(at: j + 1)
                        
                        allUsers.location.insert(allUsers.location[j], at: i)
                        allUsers.location.remove(at: j + 1)
                        
                        postId.insert(postId[j], at: i)
                        postId.remove(at: j + 1)
                        
                        allUsers.uid.insert(allUsers.uid[j], at: i)
                        allUsers.uid.remove(at: j + 1)
                        
                       // allUsers.timeStamp.insert(allUsers.timeStamp[j], at: i)
                        //allUsers.timeStamp.remove(at: j + 1)
                        
                       // allUsers.postName.insert(allUsers.postName[j], at: i)
                        //allUsers.postName.remove(at: j + 1)
                        
                        allUsers.downloadUrls.insert(allUsers.downloadUrls[j], at: i)
                        allUsers.downloadUrls.remove(at: j + 1)
                        
                        allUsers.descriptions.insert(allUsers.descriptions[j], at: i)
                        allUsers.descriptions.remove(at: j + 1)
                    }
                    j += 1
                }
                i += 1
            }
        }
        self.allUsers.date.reverse()
        self.allUsers.email.reverse()
        self.allUsers.uid.reverse()
       // self.allUsers.postName.reverse()
        self.allUsers.timeStamp.reverse()
        self.allUsers.downloadUrls.reverse()
        self.allUsers.descriptions.reverse()
        self.allUsers.city.reverse()
        self.allUsers.location.reverse()
        self.postId.reverse()
        
        tableView.reloadData()
        self.refresh.endRefreshing()
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllItemsTableViewCell
        cell.awakeFromNib()
        cell.infoLabel.text = allUsers.descriptions[indexPath.row]
        cell.cityLabel.text = allUsers.city[indexPath.row]
        let profileImageURL = allUsers.downloadUrls[indexPath.row]
        
        cell.womanImage.loadImageUsingCacheWithUrlString(profileImageURL)
        cell.locationLabel.text = allUsers.location[indexPath.item]
        let date = Date(timeIntervalSince1970:self.allUsers.date[indexPath.item])
        cell.dateLabel.text = makeDate(date: date)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.nameLabel.text = allUsers.email[indexPath.row]
        
        return cell
    }
    
    func makeDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height - 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.descriptions.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileImageURL = allUsers.downloadUrls[indexPath.item]
        
        image.loadImageUsingCacheWithUrlString(profileImageURL)
        image.contentMode = .scaleAspectFit
        //postInfo.descriptiontextField.text = allUsers.descriptions[indexPath.item]
        
        let currentCell = tableView.cellForRow(at: indexPath) as! AllItemsTableViewCell
        posterUid.text = currentCell.nameLabel.text
        dateLabel.text = currentCell.dateLabel.text!
        locationLabel.text = currentCell.locationLabel.text!
        cityLabel.text = currentCell.cityLabel.text!
        postName = postId[indexPath.item]
        print("POST NAME ",postName)
        descriptiontextField.text = currentCell.infoLabel.text
        toIdd = allUsers.uid[indexPath.row]
        imageUrl = profileImageURL
        
        show()

    }


}
