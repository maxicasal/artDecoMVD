//
//  AppDelegate.swift
//  ArtDecoMvd
//
//  Created by Gabriela Peluffo on 8/21/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        setupNavigationBar()
    }

    private func setupNavigationBar() {    
        UIApplication.shared.statusBarStyle = .lightContent
        UITabBar.appearance().tintColor = UIColor.white
      UINavigationBar.appearance().tintColor = Colors.mainColor
      UINavigationBar.appearance().backgroundColor = Colors.mainColor
      UILabel.appearance().font = UIFont(name: kFontRegular, size: 17.0)

      if let font = UIFont (name: kFontRegular, size: 17) {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: font]
      }
    }
}

