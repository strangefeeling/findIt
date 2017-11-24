//
//  MoreLauncher.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 07/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class MoreLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let cellId = "moreLauncher"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        
        return cv
    }()
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MoreCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    var tabBarController: TabBarController?
    
    @objc func showSettings(){
         if let window = UIApplication.shared.keyWindow {
            print("esu")
            let blankView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            blankView.backgroundColor = .black
            blankView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSettings)))
            window.addSubview(blankView)
        
        }
    
    }
    
    @objc func hideSettings(){
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MoreCell
        
        cell.text.text = "\(indexPath.item)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
}
