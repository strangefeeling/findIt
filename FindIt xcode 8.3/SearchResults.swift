//
//  SearchResults.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 30/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

class SearchResults: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    let tableView = UITableView()
    var cellContent = [String]()
    var delegate: ShowController!
    var searchText = ""
    
    let cellId = "cellid"
    let allUsers = EveryUser()
    var postId = [String]()
    var messagesInPost = [String]()
    var allUids = [String]()
    var cities = [String]()
    var locations = [String]()
    var date = [Double]()
    var emails = [String]()
    var downloadUrls = [String]()

    var didUserTappedSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.frame = view.frame
        view.backgroundColor = .white
       
        
        // Do any additional setup after loading the view.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        if didUserTappedSearch{
             getPosts()
        }
        //getPosts()
    }
    
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllItemsTableViewCell
        cell.awakeFromNib()
        cell.infoLabel.text = cellContent[indexPath.row]
        cell.cityLabel.text = cities[indexPath.row]
        let profileImageURL = allUsers.downloadUrls[indexPath.row]
        cell.womanImage.loadImageUsingCacheWithUrlString(profileImageURL)
        cell.locationLabel.text = locations[indexPath.item]
        let date = Date(timeIntervalSince1970:self.date[indexPath.item])
        cell.nameLabel.text = emails[indexPath.row]
        cell.dateLabel.text = makeDate(date: date)
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height - 40
    }
    
    func makeDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileImageURL = allUsers.downloadUrls[indexPath.item]
        
        image.loadImageUsingCacheWithUrlString(profileImageURL)
        image.contentMode = .scaleAspectFit
        //postInfo.descriptiontextField.text = allUsers.descriptions[indexPath.item]
        postName = postNames[indexPath.item]
        let currentCell = tableView.cellForRow(at: indexPath) as! AllItemsTableViewCell
        posterUid.text = currentCell.nameLabel.text
        dateLabel.text = currentCell.dateLabel.text!
        locationLabel.text = currentCell.locationLabel.text!
        cityLabel.text = currentCell.cityLabel.text!
       // postName = postId[indexPath.item]
        print("POST NAME ",postName)
        descriptiontextField.text = currentCell.infoLabel.text
        toIdd = allUsers.uid[indexPath.row]
        imageUrl = profileImageURL
        
        let postInfo = PostInfo()
        show(postInfo, sender: self)
        //show()

    }
    func sshowController() {
        self.delegate.showController()
    }
    
    
    func show(){
        sshowController()
    }
    
    func getPosts(){
        var i = 0
       
        
        let ref = Database.database().reference().child("allPosts").child("lost")
        ref.queryOrdered(byChild: "city").queryStarting(atValue: searchText).queryEnding(atValue: searchText+"\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.allUsers.timeStamp.removeAll()
            self.cellContent.removeAll()
            self.allUsers.uid.removeAll()
            self.cities.removeAll()
            self.allUsers.downloadUrls.removeAll()
            self.locations.removeAll()
            self.emails.removeAll()
            postNames.removeAll()
            
            print(snapshot.key)
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            
            if snapshot.exists(){
                //postNames.append(snapshot.key)
                
                for snap in snapshots {
                    postNames.append(snap.key)
                    
                    
                    if let description = snap.childSnapshot(forPath: "description").value as? String {
                        self.cellContent.append(description)
                        
                    }
                    
                    
                    if let timePosted = snap.childSnapshot(forPath: "timeStamp").value as? Int {
                        self.allUsers.timeStamp.append(timePosted)
                       // self.allUsers.dictionary["timeStamp"] = timePosted
                        self.date.append(Double(timePosted))
                        
                    }
                    
                    if let snaaap = snap.childSnapshot(forPath: "downloadURL").value as? String {
                        self.allUsers.downloadUrls.append(snaaap)
                        
                        //self.allUsers.dictionary["downloadURL"] = snaaap
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
                /*  self.date.reverse()
                 postNames.reverse()
                 self.emails.reverse()
                 self.allUsers.uid.reverse()
                 self.allUsers.postName.reverse()
                 self.allUsers.timeStamp.reverse()
                 self.allUsers.downloadUrls.reverse()
                 self.allUsers.descriptions.reverse()
                 self.cities.reverse()
                 self.locations.reverse()
                 self.postId.reverse()*/
                
                /* let dictionary = snapshot.value as! [String: Any]
                 let desc = dictionary["description"] as! String
                 self.usersSearchResults.append(desc)*/
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.didUserTappedSearch = false
                    //self.searchResults.cellContent = self.usersSearchResults
                    
              
                        
                        self.searchFound()
               
                    i += 1
                }
            }   else {
                self.searchFound()
            }

        }, withCancel: nil)
    }
    func searchFound(){
        var i = 1
        
        let ref = Database.database().reference().child("allPosts").child("found")
        ref.queryOrdered(byChild: "city").queryStarting(atValue: searchText).queryEnding(atValue: searchText+"\u{f8ff}").observeSingleEvent(of:.value, with: { (snapshot) in
            
            if snapshot.exists(){
           
                
                guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
                
                
                
                for snap in snapshots {
                    print(snap.key)
                    postNames.append(snap.key)
                    if let description = snap.childSnapshot(forPath: "description").value as? String {
                        self.cellContent.append(description)
                        
                    }
                    
                    
                    if let timePosted = snap.childSnapshot(forPath: "timeStamp").value as? Int {
                        self.allUsers.timeStamp.append(timePosted)
                        self.allUsers.dictionary["timeStamp"] = timePosted
                        self.date.append(Double(timePosted))
                        
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
                /* self.date.reverse()
                 self.emails.reverse()
                 self.allUsers.uid.reverse()
                 self.allUsers.postName.reverse()
                 self.allUsers.timeStamp.reverse()
                 self.allUsers.downloadUrls.reverse()
                 self.allUsers.descriptions.reverse()
                 self.cities.reverse()
                 self.locations.reverse()
                 self.postId.reverse()*/
                
                /* let dictionary = snapshot.value as! [String: Any]
                 let desc = dictionary["description"] as! String
                 self.usersSearchResults.append(desc)*/
                
                
                
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    
                    if i == 1{
                        
                        //self.dismiss(animated: true, completion: nil)
                        //print(postNames)
                    }
                    i += 1
                }
            }
            })
        
        
    }

    
}

