//
//  TabBarController.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 12/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase




class TabBarController: UITabBarController, UITabBarControllerDelegate, UISearchBarDelegate, GADBannerViewDelegate {
    
    
    var addItemController = AddItemController()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let allUsers = EveryUser()
    
    var usersSearchResults = [String]()
    
    let cellId = "cellid"
    let tableView = UITableView()
    var postId = [String]()
    var messagesInPost = [String]()
    var allUids = [String]()
    var cities = [String]()
    var locations = [String]()
    var date = [Double]()
    var emails = [String]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let user = Auth.auth().currentUser?.uid{
            let ref = Database.database().reference().child("users").child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as! [String: Any]
                
                let email = dictionary["email"] as! String
                UserDefaults.standard.set(email, forKey: "email")
                
                self.navigationItem.title = email
            })
            
        }
        
        // i = 0
        // handleNavigation()
        // self.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = "Back"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.checkIfUserIsLoggedIn()
        }
        self.setNeedsStatusBarAppearanceUpdate()
        handleNavigation()
        setupAd()
        self.delegate = self
    }
    
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
    
    var textInput = ""
    let searchResults = SearchResults()
    
    let ad: GADBannerView = {
        let ad = GADBannerView()
        ad.translatesAutoresizingMaskIntoConstraints = false
        return ad
    }()
    
    func setupAd(){
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
       // request.testDevices = [ "55a4e7c8d80f58b53b5f39bb7c2685e2" ];// mobui
        ad.delegate = self
        ad.adUnitID = "ca-app-pub-8501633358477205/8183851861"
        ad.rootViewController = self
        ad.load(request)
        view.addSubview(ad)
        ad.widthAnchor.constraint(equalToConstant: 320).isActive = true
        ad.heightAnchor.constraint(equalToConstant: 50).isActive = true
        ad.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0).isActive = true
        ad.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //var i = 1
        textInput = searchBar.text!
        usersSearchResults.removeAll()
        self.allUsers.descriptions.removeAll()
        self.allUsers.downloadUrls.removeAll()
        self.allUsers.uid.removeAll()
        self.cities.removeAll()
        self.locations.removeAll()
        self.date.removeAll()
        self.postId.removeAll()
        self.emails.removeAll()
        postNames.removeAll()
        
        searchResults.searchText = searchBar.text!
        searchResults.didUserTappedSearch = true
        self.searchController.searchBar.isHidden = true
        
        show(searchResults, sender: self)
        self.searchController.dismiss(animated: true, completion: nil)
        
        /*     let ref = Database.database().reference().child("allPosts").child("lost")
         ref.queryOrdered(byChild: "city").queryStarting(atValue: searchBar.text!).queryEnding(atValue: searchBar.text!+"\u{f8ff}").observeSingleEvent(of: .childAdded, with: { (snapshot) in
         print(snapshot.key)
         
         postNames.append(snapshot.key)
         //print("1 ",postNames)
         
         
         DispatchQueue.main.async {
         let anotherRef = Database.database().reference().child("allPosts").child("lost")
         anotherRef.observeSingleEvent(of: .value, with: { (snapshot) in
         })
         
         }
         
         
         
         })*/
        
    }
    
    /*   func searchFound(){
     var i = 1
     
     let ref = Database.database().reference().child("allPosts").child("found")
     ref.queryOrdered(byChild: "city").queryStarting(atValue: textInput).queryEnding(atValue: textInput+"\u{f8ff}").observeSingleEvent(of:.childAdded, with: { (snapshot) in
     if postNames.contains(snapshot.key) == false{
     postNames.append(snapshot.key)
     }
     ref.queryOrdered(byChild: "city").queryStarting(atValue: self.textInput).queryEnding(atValue: self.textInput+"\u{f8ff}").observeSingleEvent(of:  .value, with: { (snapshot) in
     
     guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
     
     
     
     for snap in snapshots {
     if let description = snap.childSnapshot(forPath: "description").value as? String {
     self.usersSearchResults.append(description)
     
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
     
     self.searchResults.cellContent = self.usersSearchResults
     self.searchResults.allUids = self.allUsers.uid
     self.searchResults.emails = self.emails
     self.searchResults.date = self.date
     self.searchResults.downloadUrls = self.allUsers.downloadUrls
     self.searchResults.cities = self.cities
     self.searchResults.locations = self.locations
     
     if i == 1{
     self.show(self.searchResults, sender: true)
     //self.dismiss(animated: true, completion: nil)
     //print(postNames)
     }
     i += 1
     }
     
     })
     
     })
     
     }*/
    
    
    func handleNavigation(){
        navigationController?.navigationBar.isHidden = false
        //let attrs = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name:"Marker Felt", size: 24)!]
        //navigationItem.title = "rytis@gmail.com"
        //UINavigationBar.appearance().titleTextAttributes = attrs
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!]
      /*  let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 39, height: 39))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "iPhone 7 Plus2")*/
       // imageView.image = image
        //navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        // navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.barTintColor = myColor
        //let myImage = UIImage(named: "iPhone 7 Plus2")
        
        
        //self.navigationController?.navigationBar.setBackgroundImage(myColor, for: .default)
        //UINavigationBar.appearance().setBackgroundImage(UIImage(named:"manoView1"), for:.default)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    func handleLogOut() {
        
        presentAlert(alert: "Proceed to Login")
        
    }
    
    
    func checkIfUserIsLoggedIn(){
        // check if the user is loged in
        //user is not logged in iskart pakraus prisiloginus
        
        if Auth.auth().currentUser?.uid == nil {
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "lll", sender: self)
            }
            
            
        } else {
            
            
        }
    }
    
    func setTabBarAppearence(){
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = myColor//UIColor(patternImage: patternImage!)
        self.tabBar.tintColor = .white
        self.tabBar.alpha = 1
    }
    
    let myView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = myColor//UIColor(patternImage: patternImage!)
        return view
    }()
    
    let addItemButton: UIButton = {
        let addbt = UIButton()
        addbt.translatesAutoresizingMaskIntoConstraints = false
        addbt.setTitle("Add item", for: .normal)
        addbt.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
        addbt.addTarget(self, action: #selector(addIteem), for: .touchUpInside)
        return addbt
    }()
    
    let logoutButton: UIButton = {
        let logout = UIButton()
        logout.setTitle("Logout", for: .normal)
        logout.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        
        return logout
    }()
    
    let browseMapButton: UIButton = {
        let browseMap = UIButton()
        browseMap.setTitle("Browse Map", for: .normal)
        browseMap.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
        browseMap.translatesAutoresizingMaskIntoConstraints = false
        browseMap.addTarget(self, action: #selector(toMap), for: .touchUpInside)
        return browseMap
    }()
    
    let coverupView: UIView = {
        let coverup = UIView()
        //coverup.backgroundColor = myColor
        
        coverup.backgroundColor = myColor//UIColor(patternImage: patternImage!)
        coverup.translatesAutoresizingMaskIntoConstraints = false
        return coverup
    }()
    
    func handleMyViewConstraints(){
        
        coverupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coverupView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        coverupView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        coverupView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        myView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        myView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        myView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        myView.addSubview(addItemButton)
        addItemButton.widthAnchor.constraint(equalTo: myView.widthAnchor).isActive = true
        addItemButton.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 1 / 3).isActive = true
        addItemButton.topAnchor.constraint(equalTo: myView.topAnchor).isActive = true
        myView.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        
        myView.addSubview(browseMapButton)
        browseMapButton.topAnchor.constraint(equalTo: addItemButton.bottomAnchor).isActive = true
        browseMapButton.widthAnchor.constraint(equalTo: myView.widthAnchor).isActive = true
        browseMapButton.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 1 / 3).isActive = true
        browseMapButton.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        
        myView.addSubview(logoutButton)
        logoutButton.topAnchor.constraint(equalTo: browseMapButton.bottomAnchor).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 1 / 3).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: myView.widthAnchor).isActive = true
    }
    
    func presentAlert(alert:String){
        let alertVC = UIAlertController(title: "Do you really want to logout?", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
            
            
        }
        let cancelAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            try! Auth.auth().signOut()
            alertVC.dismiss(animated: true, completion: nil)
            UserDefaults.standard.removeObject(forKey: "emails")
            self.performSegue(withIdentifier: "lll", sender: self)
        }
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
        // handleLogOut()
        // self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func toMap(){
        launchBool = !launchBool
        let maps = FoundItemsMap()
        //present(maps, animated: true, completion: nil)
        performSegue(withIdentifier: "toFoundItems", sender: nil)
    }
    
    @objc func showMore(){
        launchBool = !launchBool
    }
    
    var launchBool: Bool = false {
        didSet {
            if launchBool == true {
                
                view.addSubview(coverupView)
                view.addSubview(myView)
                coverupView.center.y = 0
                UIView.animate(withDuration: 0.34, animations: {
                    self.coverupView.center.y = 150
                })
                self.myView.center.y = 0
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: {
                    self.myView.center.y = 150
                }, completion: nil)
                handleMyViewConstraints()
            } else {
                
                UIView.animate(withDuration: 0.34, animations: {
                    self.myView.center.y = -150
                    self.coverupView.center.y = -110
                }, completion: { (true) in
                    self.myView.removeFromSuperview()
                    self.coverupView.removeFromSuperview()
                    
                })
                
                
            }
        }
    }
    
    @objc func addIteem(){
        launchBool = !launchBool
        present(addItemController, animated: true, completion: nil)
        //show(addItemController, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let email = UserDefaults.standard.object(forKey: "email")
        
        self.navigationItem.title = email as? String
        self.searchController.searchBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        
        setTabBarAppearence()
        // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addIteem))
        let moreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 8, height: 24))
        moreButton.setImage(UIImage(named: "Untitled"), for: .normal)
        // moreButton.contentEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        moreButton.addTarget(self, action: #selector(showMore), for: .touchUpInside)
        // pleciam touch area
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: moreButton)
        
        /* let tabOne = MyItems()
         let tabOneBarItem = UITabBarItem(title: "All Items", image: UIImage(named:"defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
         tabOne.title = "My Items"
         
         tabOne.tabBarItem = tabOneBarItem
         tabOneBarItem.badgeColor = .red
         let tabTwo = AllItems()
         let tabTwoBarItem2 = UITabBarItem(title: "My Items", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
         tabTwoBarItem2.badgeColor = .red
         tabTwo.tabBarItem = tabTwoBarItem2
         tabTwo.title = "All Items"
         
         
         let allItems = AllItems()
         let myItems = MyItems()*/
        // self.viewControllers = [AllItems(), MyItems()]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*   func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
     if let title = viewController.title{
     navigationItem.title = title
     
     }
     
     }*/
    
    
}

