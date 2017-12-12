//
//  SearchResults.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 30/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

class SearchResults: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate  {
    
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
    
    var isItFoundOrLost = [String]()
    
    var didUserTappedSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|-[v0]-50-|", views: tableView)
        view.backgroundColor = .white
        setupAd()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if didUserTappedSearch{
            getPosts()
            
        }
        //getPosts()
    }
    
    let ad: GADBannerView = {
        let ad = GADBannerView()
        ad.translatesAutoresizingMaskIntoConstraints = false
        return ad
    }()
    
    func setupAd(){
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //request.testDevices = [ "55a4e7c8d80f58b53b5f39bb7c2685e2" ];// mobui
        ad.delegate = self
        ad.adUnitID = "ca-app-pub-8501633358477205/8183851861"
        ad.rootViewController = self
        ad.load(request)
        view.addSubview(ad)
        ad.widthAnchor.constraint(equalToConstant: 320).isActive = true
        ad.heightAnchor.constraint(equalToConstant: 50).isActive = true
        ad.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        ad.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
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
        cell.dateLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.locationLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.cityLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.infoLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 2.5 + 10 * (UIScreen.main.bounds.height / 33.35 + 8)//UIScreen.main.bounds.height// - 40
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
        
        foundOrLost = isItFoundOrLost[indexPath.row]
        
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
            self.date.removeAll()
            postNames.removeAll()
            
            print(snapshot.key)
            
            
            
            if snapshot.exists(){
                //postNames.append(snapshot.key)
                guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
                for snap in snapshots {
                    self.isItFoundOrLost.append("lost")
                    postNames.append(snap.key)
                    
                    if let description = snap.childSnapshot(forPath: "description").value as? String {
                        self.cellContent.append(description)
                        
                    }
                    
                    
                    if let timePosted = snap.childSnapshot(forPath: "timeStamp").value as? Int {
                        self.allUsers.timeStamp.append(timePosted)
                        
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
                    //self.tableView.reloadData()
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
                    self.isItFoundOrLost.append("found")
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
                
                
                
                
            }
            
            DispatchQueue.main.async {
                self.sortPosts(timee: self.date)
            }
        })
        
        
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
                        
                        date.insert(date[j], at: i)
                        date.remove(at: j + 1)
                        
                        emails.insert(emails[j], at: i)
                        emails.remove(at: j + 1)
                        
                        isItFoundOrLost.insert(isItFoundOrLost[j], at: i)
                        isItFoundOrLost.remove(at: j + 1)
                        
                        cities.insert(cities[j], at: i)
                        cities.remove(at: j + 1)
                        
                        locations.insert(locations[j], at: i)
                        locations.remove(at: j + 1)
                        
                        postNames.insert(postNames[j], at: i)
                        postNames.remove(at: j + 1)
                        
                        allUsers.uid.insert(allUsers.uid[j], at: i)
                        allUsers.uid.remove(at: j + 1)
                        
                        allUsers.timeStamp.insert(allUsers.timeStamp[j], at: i)
                        allUsers.timeStamp.remove(at: j + 1)
                        
                        allUsers.downloadUrls.insert(allUsers.downloadUrls[j], at: i)
                        allUsers.downloadUrls.remove(at: j + 1)
                        
                        cellContent.insert(cellContent[j], at: i)
                        cellContent.remove(at: j + 1)
                    }
                    j += 1
                }
                i += 1
            }
            
            
        }
        self.date.reverse()
        self.emails.reverse()
        self.allUsers.uid.reverse()
        postNames.reverse()
        self.allUsers.timeStamp.reverse()
        self.allUsers.downloadUrls.reverse()
        self.allUsers.descriptions.reverse()
        self.cities.reverse()
        self.locations.reverse()
        self.postId.reverse()
        cellContent.reverse()
        self.isItFoundOrLost.reverse()
        
        self.tableView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
}

