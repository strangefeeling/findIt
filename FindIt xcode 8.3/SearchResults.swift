//
//  SearchResults.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 30/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

class SearchResults: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate, UITextFieldDelegate, UISearchBarDelegate {
    
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
    
    let topView: UIView = {
       let view = UIView()
       // view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = myColor
        return view
    }()
    

    
    let lostFoundSegentedControll: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Serach Found"," Search Lost"])
        sc.backgroundColor = myColor//UIColor(patternImage: patternImage!)
        
        sc.tintColor = .white
        let borderColor = myColor//UIColor(patternImage: patternImage!)//myColor
        let attrs = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Avenir Next", size: 16)!
        ]
        sc.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        sc.setTitleTextAttributes(attrs as [NSObject : AnyObject] , for: .normal)
        sc.layer.borderColor = borderColor.cgColor
        sc.layer.borderWidth = 0.5
        sc.addTarget(self, action: #selector(whatToSearch), for: .valueChanged)
        // sc.backgroundColor = myColor
        sc.selectedSegmentIndex = 0
        return sc
    }()

    var searchWhat = "found"
    
    @objc func whatToSearch(){
        if lostFoundSegentedControll.selectedSegmentIndex == 1{
            searchWhat = "lost"
            getPosts()
        } else {
            searchWhat = "found"
            getPosts()
        }
    }

    
    var didUserTappedSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(lostFoundSegentedControll)
        /*searchTextField.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
        view.addSubview(topView)
        topView.addSubview(dismissButton)
        topView.addSubview(searchTextField)
        view.addSubview(lostFoundSegentedControll)
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        dismissButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 24).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 4).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        searchTextField.leftAnchor.constraint(equalTo: dismissButton.rightAnchor).isActive = true
        searchTextField.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalTo: dismissButton.heightAnchor).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: topView.rightAnchor,constant: -4).isActive = true
        */
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|-30-[v0]-|", views: tableView)
        view.backgroundColor = .white
        setupAd()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.allUsers.timeStamp.removeAll()
        self.cellContent.removeAll()
        self.allUsers.uid.removeAll()
        self.cities.removeAll()
        self.allUsers.downloadUrls.removeAll()
        self.locations.removeAll()
        self.emails.removeAll()
        self.date.removeAll()
        postNames.removeAll()
        tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
       // navigationController?.isNavigationBarHidden = true
        if didUserTappedSearch{
            handleSearch()
            didUserTappedSearch = false
            
        }
        //getPosts()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        didUserTappedSearch = true
        self.searchController.dismiss(animated: true, completion: nil)
        getPosts()
   
               
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    var usersSearchResults = [String]()
    
    func handleSearch(){
        
        searchController.searchBar.delegate = self
        
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = myColor.cgColor
        searchController.searchBar.placeholder = "Enter City Name"
        searchController.searchBar.barTintColor = myColor//UIColor(patternImage: patternImage!)
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
        self.searchController.hidesNavigationBarDuringPresentation = false;
        self.definesPresentationContext = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        present(searchController, animated: true, completion: nil)
        
        
        
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
        
        foundOrLost = searchWhat
        
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
        
        
        let ref = Database.database().reference().child("allPosts").child(searchWhat)
        ref.queryOrdered(byChild: "city").queryStarting(atValue: searchController.searchBar.text).queryEnding(atValue: searchController.searchBar.text!+"\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                self.noResults.removeFromSuperview()
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
                    self.tableView.reloadData()
                    self.didUserTappedSearch = false
                }
            }   else {
                self.allUsers.timeStamp.removeAll()
                self.cellContent.removeAll()
                self.allUsers.uid.removeAll()
                self.cities.removeAll()
                self.allUsers.downloadUrls.removeAll()
                self.locations.removeAll()
                self.emails.removeAll()
                self.date.removeAll()
                self.isItFoundOrLost.removeAll()
                postNames.removeAll()
                self.tableView.reloadData()
                self.view.addSubview(self.noResults)
                self.noResults.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.noResults.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                self.noResults.widthAnchor.constraint(equalToConstant: 100).isActive = true
                self.noResults.heightAnchor.constraint(equalToConstant: 100).isActive = true
                //self.searchFound()
            }
            
        }, withCancel: nil)
    }
  /*  func searchFound(){
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
        
        
    }*/
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
        noResults.removeFromSuperview()
        self.tableView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        if date.count != 0{
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        } else {
            view.addSubview(noResults)
            noResults.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noResults.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            noResults.widthAnchor.constraint(equalToConstant: 100).isActive = true
            noResults.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
    }
    
    let noResults: UILabel = {
       let label = UILabel()
        label.text = "No Results"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getPosts()
        textField.resignFirstResponder()
        return true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

