//
//  FirstPage.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 24/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class FirstPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ShowController {
    
    var collectionView: UICollectionView?
    let cellId = "blah"
   
    
    func showController() {
        let vc = PostInfo()
        show(vc, sender: self)
    }
    
    let myImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named:"manoViewVisas")
        return image
    }()
    
    let lostFoundSegentedControll: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Found","Lost"])
        sc.backgroundColor = UIColor(patternImage: patternImage!)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        let borderColor = UIColor(patternImage: patternImage!)//myColor
        let attrs = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Avenir Next", size: 16)!
        ]
        
        sc.setTitleTextAttributes(attrs as [NSObject : AnyObject] , for: .normal)
        sc.layer.borderColor = borderColor.cgColor
        sc.layer.borderWidth = 0.5
        // sc.backgroundColor = myColor
        //sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentedControll), for: .valueChanged)
        return sc
    }()
    
    var didUserTapped = false
    
    @objc func handleSegmentedControll(){
        didUserTapped = true
        if lostFoundSegentedControll.selectedSegmentIndex == 1{
            
            let path = IndexPath(item: 1, section: 0)
            collectionView?.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
            DispatchQueue.main.async {
                self.didUserTapped = false
            }
        } else {
            let path = IndexPath(item: 0, section: 0)
            collectionView?.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
            
            DispatchQueue.main.async {
                self.didUserTapped = false
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myImage)
        myImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        myImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        myImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -80).isActive = true
        setup()
        
        collectionView?.register(AllItemsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(AllLostItems.self, forCellWithReuseIdentifier: cellId2)
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(MyItemsCell.self, forCellWithReuseIdentifier: cellId)
        
        
        collectionView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        
        
        
        view.addSubview(collectionView!)
        view.addSubview(lostFoundSegentedControll)
        lostFoundSegentedControll.topAnchor.constraint(equalTo: view.topAnchor, constant: -1).isActive = true
        lostFoundSegentedControll.leftAnchor.constraint(equalTo: view.leftAnchor,constant: -2).isActive = true
        lostFoundSegentedControll.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 2).isActive = true
        lostFoundSegentedControll.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        /*  collectionView?.topAnchor.constraint(equalTo: lostFoundSegentedControll.bottomAnchor, constant: 0).isActive = true
         collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
         collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
         collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50).isActive = true*/
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView!)
        view.addConstraintsWithFormat(format: "V:|-28-[v0]|", views: collectionView!)
        
        collectionView?.contentInset = UIEdgeInsets(top: 30, left: -1, bottom: 0, right: 1)
        
    }
    
    var whichCell = UICollectionViewCell()
    let cellId2 = "cellId2"
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AllItemsCollectionViewCell
            cell.awakeFromNib()
            cell.delegate = self
            //lostFoundSegentedControll.selectedSegmentIndex = 1
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! AllLostItems
            cell.awakeFromNib()
            cell.delegate = self
            
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if didUserTapped == false{
            if scrollView.contentOffset.x > UIScreen.main.bounds.width / 2{
                lostFoundSegentedControll.selectedSegmentIndex = 1
            } else {
                lostFoundSegentedControll.selectedSegmentIndex = 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
}
