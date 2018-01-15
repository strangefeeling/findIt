//
//  TabBarController.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 12/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

protocol SomeDelegate {
    func reloadData()
}

class TabBarController: UITabBarController, UITabBarControllerDelegate , GADBannerViewDelegate, UISearchBarDelegate , printSomething {
    
    var someDelegate: SomeDelegate?
    
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
    
    func makeSomething() {
        
        let tabOne = FirstPage()
        let tabTwo = SecondPage()
        let tabThree = MessagesController()
        let tabOneBarItem = UITabBarItem(title: "All Posts", image: UIImage(named:"group"), selectedImage: UIImage(named: "group (2)"))
        let taTwoBarItem = UITabBarItem(title: "My Posts", image: UIImage(named:"user (2)"), selectedImage: UIImage(named: "user (2)"))
        let taThreeBarItem = UITabBarItem(title: "Messages", image: UIImage(named:"speech-bubble (1)"), selectedImage: UIImage(named: "speech-bubble (1)"))
        tabOne.tabBarItem = tabOneBarItem
        tabTwo.tabBarItem = taTwoBarItem
        tabThree.tabBarItem = taThreeBarItem
        
        //foundCity = searchBar.text!
        
        setViewControllers([tabOne,tabTwo, tabThree], animated: false)
        searchController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser?.uid{
            let ref = Database.database().reference().child("users").child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as! [String: Any]
                
                let email = dictionary["name"] as! String
                UserDefaults.standard.set(email, forKey: "email")
                
                self.navigationItem.title = email
                
            })
            
        }
        
        // i = 0
        // handleNavigation()
        // self.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //     print(navigationController?.navigationBar.frame.height, "<------") // 6s plus 44, visi 44
        DispatchQueue.main.async {
            self.checkIfUserIsLoggedIn()
        }
        self.setNeedsStatusBarAppearanceUpdate()
        handleNavigation()
        setupAd()
        self.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeLaunchBool))
        dimScreen.addGestureRecognizer(tap)
    }
    
    func changeLaunchBool(){
        launchBool = false
    }
    
    let dimScreen: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    func handleSearch(){
        
        searchController.searchBar.delegate = self
        
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = myColor.cgColor
        searchController.searchBar.placeholder = "Enter City Name"
        searchController.searchBar.barTintColor = myColor//UIColor(patternImage: patternImage!)
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: myTextColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
        self.searchController.hidesNavigationBarDuringPresentation = false;
        self.definesPresentationContext = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        present(searchController, animated: true, completion: nil)
        
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let tabOne = NewSearchResults()
        let tabTwo = SecondPage()
        let tabThree = MessagesController()
        let tabOneBarItem = UITabBarItem(title: "Posts by City", image: UIImage(named:"skyline (2)"), selectedImage: UIImage(named: "skyline (2)"))
        let taTwoBarItem = UITabBarItem(title: "My Posts", image: UIImage(named:"user (2)"), selectedImage: UIImage(named: "user (2)"))
        let taThreeBarItem = UITabBarItem(title: "Messages", image: UIImage(named:"speech-bubble (1)"), selectedImage: UIImage(named: "speech-bubble (1)"))
        tabOne.tabBarItem = tabOneBarItem
        tabTwo.tabBarItem = taTwoBarItem
        tabThree.tabBarItem = taThreeBarItem
        
        foundCity = searchBar.text!.folding(options: .diacriticInsensitive, locale: .current).capitalized
        print(foundCity)
        self.selectedIndex = 0
        setViewControllers([tabOne,tabTwo, tabThree], animated: false)
        searchController.dismiss(animated: true, completion: nil)
        
        //tabOneBarItem.badgeColor = .red
    }
    
    
    
    var textInput = ""
    let searchResults = NewSearchResults()
    
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
    
    
    

    
    
    func handleNavigation(){
        navigationController?.navigationBar.isHidden = false
        //let attrs = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name:"Marker Felt", size: 24)!]
        //navigationItem.title = "rytis@gmail.com"
        //UINavigationBar.appearance().titleTextAttributes = attrs
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
        navigationController?.navigationBar.tintColor = myTextColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: myTextColor, NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!]
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
        // tab bar background
        self.tabBar.barTintColor = .white//UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
//myColor//UIColor(red: 230/255, green: 239/255, blue: 1, alpha: 1)//myColor//UIColor(red: 241/255, green: 1, blue: 248/255, alpha: 1)//myColor//UIColor(patternImage: patternImage!)
        //self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .darkText//myTextColor//UIColor(red: 178/255, green: 34/255, blue: 34/255, alpha: 1)
//.white//myTextColor
        //paselectinto spalva
        self.tabBar.tintColor = myTextColor//.darkText//.red//UIColor(red: 178/255, green: 34/255, blue: 34/255, alpha: 1)

        
        
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
        addbt.setTitleColor(myTextColor, for: .normal)
        return addbt
    }()
    
    let logoutButton: UIButton = {
        let logout = UIButton()
        logout.setTitle("Logout", for: .normal)
        logout.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        logout.setTitleColor(myTextColor, for: .normal)
        
        return logout
    }()
    
    let browseMapButton: UIButton = {
        let browseMap = UIButton()
        browseMap.setTitle("Browse Map", for: .normal)
        browseMap.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
        browseMap.translatesAutoresizingMaskIntoConstraints = false
        browseMap.addTarget(self, action: #selector(toMap), for: .touchUpInside)
        browseMap.setTitleColor(myTextColor, for: .normal)
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
            doINeedToSearch = false
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
                view.addSubview(dimScreen)
                view.addSubview(coverupView)
                view.addSubview(myView)
                coverupView.center.y = 0
                UIView.animate(withDuration: 0.34, animations: {
                    self.coverupView.center.y = 150
                    self.dimScreen.alpha = 0.5
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
                    self.dimScreen.alpha = 0
                }, completion: { (true) in
                    self.myView.removeFromSuperview()
                    self.dimScreen.removeFromSuperview()
                    self.coverupView.removeFromSuperview()
                    
                })
                
                
            }
        }
    }
    
    /* let coverUp: UIView = {
     let coverUp = UIView()
     coverUp.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
     coverUp.backgroundColor = myColor
     return coverUp
     }()*/
    
    @objc func addIteem(){
        launchBool = !launchBool
        present(addItemController, animated: true, completion: nil)
        //show(addItemController, sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.backgroundColor = myColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let email = UserDefaults.standard.object(forKey: "email")
        
        self.navigationItem.title = email as? String
        self.searchController.searchBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        
        setTabBarAppearence()
        // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addIteem))
        let moreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 8, height: 24))
        
        
        moreButton.setImage(UIImage(named: "Untitled")?.withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.tintColor = myTextColor
        // moreButton.contentEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        moreButton.addTarget(self, action: #selector(showMore), for: .touchUpInside)
        // pleciam touch area
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: moreButton)
        
     
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    /*   func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
     if let title = viewController.title{
     navigationItem.title = title
     
     }
     
     }*/
    
    
}

