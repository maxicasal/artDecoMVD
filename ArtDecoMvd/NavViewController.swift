//
//  NavViewController.swift
//  ArtDecoMvd
//
//  Created by Gabriela Peluffo on 8/25/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {
    
    @IBOutlet var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        navBar.barTintColor = Colors.mainColor
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = Fonts.navBarFont
        navBar.backItem?.title = ""
    }
}
