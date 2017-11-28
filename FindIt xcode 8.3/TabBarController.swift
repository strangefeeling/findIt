//
//  TabBarController.swift
//  ManoAplikacija 1.2
//
//  Created by Rytis on 12/10/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    

    var addItemController = AddItemController()
    
    override func viewDidAppear(_ animated: Bool) {
        print(UserDefaults.standard.object(forKey: "userUid")," userdafualts")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.checkIfUserIsLoggedIn()
        }
        self.setNeedsStatusBarAppearanceUpdate()
         handleNavigation()
        self.delegate = self
    }
    
    
    func handleNavigation(){
        navigationController?.navigationBar.isHidden = false
        let attrs = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name:"Marker Felt", size: 24)!]
        //navigationItem.title = "rytis@gmail.com"
        //UINavigationBar.appearance().titleTextAttributes = attrs
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!]
       // navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.barTintColor = myColor
        
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
        self.tabBar.barTintColor = myColor
        self.tabBar.tintColor = .white
        self.tabBar.alpha = 1
    }
    
    let myView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = myColor
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
        coverup.backgroundColor = myColor
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
                UIView.animate(withDuration: 0.6, animations: {
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
       show(addItemController, sender: self)
    }
    
    @objc func doNothing(){
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(doNothing))

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
