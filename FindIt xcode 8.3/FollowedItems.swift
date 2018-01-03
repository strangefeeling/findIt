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
    
    
    
    var isItFoundOrLost = [String]()
    
    func show(){
        sshowController()
    }
    
    func sshowController() {
        self.delegate.showController()
    }
    
    override func awakeFromNib() {
       // observeOneTime()
        getFollowed()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        contentView.addSubview(tableView)
        tableView.addSubview(refresh)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50).isActive = true
        tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -85).isActive = true
        tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(getFollowed), for: .valueChanged)
        return refresh
    }()
    
    var noResults: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "To follow a post you need to write a comment under it"
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func showNoResults(){
        contentView.addSubview(self.noResults)
        noResults.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        noResults.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        noResults.heightAnchor.constraint(equalToConstant: 80).isActive = true
        noResults.widthAnchor.constraint(equalToConstant: 210).isActive = true
        
    }
    
    var keys = [String]()
    
    func getFollowed(){
        self.allUsers.date.removeAll()
        self.datee.removeAll()
        //self.allUsers.date.removeAll()
        self.allUsers.email.removeAll()
        self.allUsers.uid.removeAll()
        self.allUsers.postName.removeAll()
        self.allUsers.timeStamp.removeAll()
        self.allUsers.downloadUrls.removeAll()
        self.allUsers.descriptions.removeAll()
        self.allUsers.city.removeAll()
        self.allUsers.location.removeAll()
        self.postId.removeAll()
        self.isItFoundOrLost.removeAll()
    
        
        let user = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(user!).child("followed")
        ref.queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.allUsers.date.removeAll()
            self.datee.removeAll()
            //self.allUsers.date.removeAll()
            self.allUsers.email.removeAll()
            self.allUsers.uid.removeAll()
            self.allUsers.postName.removeAll()
            self.allUsers.timeStamp.removeAll()
            self.allUsers.downloadUrls.removeAll()
            self.allUsers.descriptions.removeAll()
            self.allUsers.city.removeAll()
            self.allUsers.location.removeAll()
            self.postId.removeAll()
            self.isItFoundOrLost.removeAll()
            
            if snapshot.exists(){
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for snap in snapshots{
                print(snap.key)
                self.allUsers.postName.append(snap.key) // ieskosim kuriu postu pavadinimas sutampa su followed pavadinimu
                self.getFollowedPosts(post: snap.key)
                
                }
               
            }//cia if exists
            else {
                
                if self.allUsers.descriptions.count == 0 {
                self.tableView.reloadData()
                    self.showNoResults()
                }
                if self.allUsers.postName.count > 0{
                    self.noResults.removeFromSuperview()
                }
                self.refresh.endRefreshing()
            }
        })
    }
    
    
  /*  func observeOneTime(){
        let ref = Database.database().reference().child("allPosts").child("comments")
        ref.queryOrdered(byChild: "timeStamp").observe( .childAdded, with: { (snapshot) in
            let dict = snapshot.value as! [String: Any]
            
           // let comment = dict["comment"] as! String
     
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
                        
                    }
                }
                
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                
            }
            //ref.removeAllObservers()
        }, withCancel: nil)
    }*/
    
    func getFollowedPosts(post: String){
        let foundRef = Database.database().reference().child("allPosts")
       
      //----
        
        foundRef.child("found").child(post).observeSingleEvent(of: .value, with: { (snapshot) in
                let dict = snapshot.value as? [String: Any]
                if snapshot.exists(){
                 //     print("found snapshot ",snapshot)
                    self.postId.append(snapshot.key)
                    self.isItFoundOrLost.append("found")
                    let date = dict?["timeStamp"] as! Double
                    self.datee.append(date)
                    
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
                        if self.allUsers.descriptions.count == 0 {
                            self.tableView.reloadData()
                            self.showNoResults()
                        }
                        if self.allUsers.postName.count > 0{
                            self.noResults.removeFromSuperview()
                        }
                        self.getLostFollowed(post: post)
                        foundRef.removeAllObservers()
                    }
                   
                }
                else{
                    DispatchQueue.main.async {
                        self.getLostFollowed(post: post)
                        foundRef.removeAllObservers()
                    }
                   
                }
            
            })//cia foundRef snapshot


        
    }
    
    var datee = [Double]()
    
    func getLostFollowed(post: String){
        let lostRef = Database.database().reference().child("allPosts")
        lostRef.child("lost").child(post).observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as? [String: Any]
            if snapshot.exists(){
               // print("lost snapshot ",snapshot)
                self.isItFoundOrLost.append("lost")
                self.postId.append(snapshot.key)
                
                let date = dict?["timeStamp"] as! Double
                self.datee.append(date)
                
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
                    self.refresh.endRefreshing()
                    //self.sortPosts(timee: self.allUsers.date)
                    self.findSameNumbers(gooNumbers: self.allUsers.postName, SortNumbers: self.postId)
                    lostRef.removeAllObservers()
                 
                    if self.allUsers.descriptions.count == 0 {
                        self.tableView.reloadData()
                        self.showNoResults()
                    }
                    if self.allUsers.postName.count > 0{
                        self.noResults.removeFromSuperview()
                    }
                    
                }
            } else{
                
              

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                    //self.sortPosts(timee: self.allUsers.date)
                    self.findSameNumbers(gooNumbers: self.allUsers.postName, SortNumbers: self.postId)
                    lostRef.removeAllObservers()
                    
                }
                
            }
            
        })//cia lostRef

    }

    
  /*  func sortPosts(timee: [Double]){
        var time = timee
        
        if allUsers.date.count == allUsers.postName.count{
        
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
                        
                        datee.insert(datee[j], at: i)
                        datee.remove(at: j + 1)
                        
                        isItFoundOrLost.insert(isItFoundOrLost[j], at: i)
                        isItFoundOrLost.remove(at: j + 1)
                        
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
                }// cia if date == email
         /*   datee.reverse()
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
            self.isItFoundOrLost.reverse()
            // self.allUsers.date = datee
            */
            tableView.reloadData()
            self.refresh.endRefreshing()
            print(allUsers.descriptions)
            }
            
           

        }
    
    }*/
    

    func findSameNumbers(gooNumbers: [String], SortNumbers: [String]){
        var goodNumbers = gooNumbers
        var toSortNumbers = SortNumbers
        var i:Int = 0
        if postId.count == allUsers.postName.count && postId.count > 1{
        while i < goodNumbers.count{
            //print(goodNumbers[i])
            var j:Int = 0
            while j < toSortNumbers.count{
                // print(toSortNumbers[j])
                
                if toSortNumbers[j] == goodNumbers[i]{
                    //print("sutamp ", goodNumbers[i], " ir ",toSortNumbers[j])
                    toSortNumbers.insert(toSortNumbers[j], at: i)
                    toSortNumbers.remove(at: j+1)
                    
              //      allUsers.date.insert(allUsers.date[j], at: i)
              //      allUsers.date.remove(at: j + 1)
                    
                    datee.insert(datee[j], at: i)
                    datee.remove(at: j + 1)
                    
                    isItFoundOrLost.insert(isItFoundOrLost[j], at: i)
                    isItFoundOrLost.remove(at: j + 1)
                    
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
            datee.reverse()
          //  self.allUsers.date.reverse()
            self.allUsers.email.reverse()
            self.allUsers.uid.reverse()
            // self.allUsers.postName.reverse()
            self.allUsers.timeStamp.reverse()
            self.allUsers.downloadUrls.reverse()
            self.allUsers.descriptions.reverse()
            self.allUsers.city.reverse()
            self.allUsers.location.reverse()
            self.postId.reverse()
            self.isItFoundOrLost.reverse()
            // self.allUsers.date = datee
            
            tableView.reloadData()
            self.refresh.endRefreshing()
    }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllItemsTableViewCell
        cell.awakeFromNib()
        cell.infoLabel.text = allUsers.descriptions[indexPath.row]
        cell.cityLabel.text = allUsers.city[indexPath.row]
        let profileImageURL = allUsers.downloadUrls[indexPath.row]
        
        cell.womanImage.loadImageUsingCacheWithUrlString(profileImageURL)
        cell.locationLabel.text = allUsers.location[indexPath.row]
        
        let date = Date(timeIntervalSince1970:datee[indexPath.row])
        cell.dateLabel.text = makeDate(date: date)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.nameLabel.text = allUsers.email[indexPath.row]
        cell.dateLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.locationLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.infoLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.cityLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)

        
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
        return UIScreen.main.bounds.height / 2.5 + 10 * (UIScreen.main.bounds.height / 33.35 + 8)//UIScreen.main.bounds.height// - 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.descriptions.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileImageURL = allUsers.downloadUrls[indexPath.item]
        print(indexPath.row)
        image.loadImageUsingCacheWithUrlString(profileImageURL)
        image.contentMode = .scaleAspectFit
        //postInfo.descriptiontextField.text = allUsers.descriptions[indexPath.item]
        
        let currentCell = tableView.cellForRow(at: indexPath) as! AllItemsTableViewCell
        posterUid.text = currentCell.nameLabel.text
        dateLabel.text = currentCell.dateLabel.text!
        locationLabel.text = currentCell.locationLabel.text!
        cityLabel.text = currentCell.cityLabel.text!
        postName = postId[indexPath.row]
        foundOrLost = isItFoundOrLost[indexPath.row]
        
        descriptiontextField.text = currentCell.infoLabel.text
        toIdd = allUsers.uid[indexPath.row]
        imageUrl = profileImageURL
        
        show()

    }


}
