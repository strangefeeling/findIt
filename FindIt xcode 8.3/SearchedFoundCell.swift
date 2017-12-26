//
//  SearchedFoundCell.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 22/12/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

class SearchedFoundCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource  {
    var delegate: ShowController!
    
    func show(){
        sshowController()
    }
    
    let noResults: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
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
    var cellContent = [String]()
    
    override func awakeFromNib() {
        getPosts()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        //tableView.layoutIfNeeded()
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: cellId)
        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(refresh)
        //tableView.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        contentView.addConstraintsWithFormat(format: "V:|-50-[v0]-85-|", views: tableView)
        
        contentView.addSubview(getAllItemsButton)
        getAllItemsButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        getAllItemsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60).isActive = true
        getAllItemsButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        getAllItemsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
    
    lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        return refresh
    }()
    var a = 5
    
    func refreshPosts(){
        a = 5
        i = 0
        self.allUsers.timeStamp.removeAll()
        self.cellContent.removeAll()
        self.allUsers.uid.removeAll()
        self.cities.removeAll()
        self.allUsers.downloadUrls.removeAll()
        self.locations.removeAll()
        self.emails.removeAll()
        self.date.removeAll()
        
        self.howManySnaps.removeAll()
        getPosts()
    }
    
    let getAllItemsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View all posts", for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)
        button.addTarget(self, action: #selector(TabBarController.makeSomething), for: .touchUpInside)
        return button
    }()
    
    func getPosts(){
    
        let ref = Database.database().reference().child("allPosts").child("found").child(foundCity)
        ref.queryLimited(toLast: UInt(a)).queryOrdered(byChild: "timeStamp").observe( .value, with: { (snapshot) in
            
            self.allUsers.timeStamp.removeAll()
            self.cellContent.removeAll()
            self.allUsers.uid.removeAll()
            self.cities.removeAll()
            self.allUsers.downloadUrls.removeAll()
            self.locations.removeAll()
            self.emails.removeAll()
            self.date.removeAll()
            
            self.howManySnaps.removeAll()
            

            if snapshot.exists(){
                self.noResults.removeFromSuperview()
                //postNames.append(snapshot.key)
                
                guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
                for snap in snapshots {
                    
                    self.howManySnaps.append(snap.key)
                    
                    
                    
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
                    self.i += 1
                    
                }
                self.allUsers.timeStamp.reverse()
                self.cellContent.reverse()
                self.allUsers.uid.reverse()
                self.cities.reverse()
                self.allUsers.downloadUrls.reverse()
                self.locations.reverse()
                self.emails.reverse()
                self.date.reverse()
                self.howManySnaps.reverse()
                postNames.reverse()
                
                
                DispatchQueue.main.async {
                    // self.sortPosts(timee: self.date)
                    print( self.howManySnaps, "<------")
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                    //self.i += 5
                    
                }
            }   else {
             /*   self.allUsers.timeStamp.removeAll()
                self.cellContent.removeAll()
                self.allUsers.uid.removeAll()
                self.cities.removeAll()
                self.allUsers.downloadUrls.removeAll()
                self.locations.removeAll()
                self.emails.removeAll()
                self.date.removeAll()
                
                postNames.removeAll()*/
                self.tableView.reloadData()
                self.contentView.addSubview(self.noResults)
                self.noResults.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
                self.noResults.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
                self.noResults.widthAnchor.constraint(equalToConstant: 100).isActive = true
                self.noResults.heightAnchor.constraint(equalToConstant: 100).isActive = true
                //self.searchFound()
            }
            
        }, withCancel: nil)
    }

    
    
  /*  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (velocity.y > 0){
            UIView.animate(withDuration: 1, animations: { 
                self.getAllItemsButton.frame.origin.y = 0
            })
        } else if velocity.y < 0 {
            print("i virsu")
            UIView.animate(withDuration: 1, animations: {
                self.getAllItemsButton.frame.origin.y = -30
            })
        }
    }*/
    
    var lastContentOffset: CGFloat = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.lastContentOffset > scrollView.contentOffset.y {
            UIView.animate(withDuration: 0.3, animations: {
                self.getAllItemsButton.frame.size.height = 30
                self.getAllItemsButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)
            })
        } else if self.lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0{
            UIView.animate(withDuration: 0.3, animations: {
                self.getAllItemsButton.frame.size.height = 0
                self.getAllItemsButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 0)
            })
            
        }
        if scrollView.contentOffset.y == 0 {
            UIView.animate(withDuration: 0.3, animations: { 
                self.getAllItemsButton.frame.size.height = 30
                self.getAllItemsButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 16)
            })
            
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 2.5 + 10 * (UIScreen.main.bounds.height / 33.35 + 8)//UIScreen.main.bounds.height// - 40
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellContent.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as!
        AllItemsTableViewCell
        cell.awakeFromNib()
        cell.infoLabel.text = cellContent[indexPath.row]
        cell.infoLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        cell.cityLabel.text = cities[indexPath.row]
        cell.cityLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        let profileImageURL = allUsers.downloadUrls[indexPath.row]
        cell.womanImage.loadImageUsingCacheWithUrlString(profileImageURL)
        cell.locationLabel.text = locations[indexPath.item]
        
        cell.locationLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        let date = Date(timeIntervalSince1970:self.date[indexPath.item])
        cell.dateLabel.text = makeDate(date: date)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.nameLabel.text = emails[indexPath.row]
        cell.dateLabel.font = UIFont(name: "Avenir Next", size: UIScreen.main.bounds.height / 33.35)
        
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
        print(self.howManySnaps,"didSelect")
        
        let profileImageURL = allUsers.downloadUrls[indexPath.item]
        
        image.loadImageUsingCacheWithUrlString(profileImageURL)
        image.contentMode = .scaleAspectFit
        //postInfo.descriptiontextField.text = allUsers.descriptions[indexPath.item]
        
        let currentCell = tableView.cellForRow(at: indexPath) as! AllItemsTableViewCell
        posterUid.text = currentCell.nameLabel.text
        dateLabel.text = currentCell.dateLabel.text!
        locationLabel.text = currentCell.locationLabel.text!
        cityLabel.text = currentCell.cityLabel.text!
        postName = howManySnaps[indexPath.item]
        toIdd = allUsers.uid[indexPath.row]
        
        foundOrLost = "found"
        descriptiontextField.text = currentCell.infoLabel.text
        imageUrl = profileImageURL
        
        show()
    }
    var i = 0
    
    var howManySnaps = [String]()
    
    
    
       func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lasItem = cellContent.count - 3
        print("count", cellContent.count, i, a)
        if lasItem > 0 {
            if indexPath.row == lasItem{
                
                if i <= cellContent.count{
                    print("load more ", i, a)
                    a += 5
                    //addMoreRows()
                    getPosts()
                }
                // handle your logic here to get more items, add it to dataSource and reload tableview
            }
        }
    }

}
