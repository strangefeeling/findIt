//
//  NavController.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 07/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class NavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        // Do any additional setup after loading the view.
    }

    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
   
}
