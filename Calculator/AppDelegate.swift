//
//  AppDelegate.swift
//  Calculator
//
//  Created by Garret Koontz on 1/9/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        let color = UIColor(red: 245/255, green: 226/255, blue: 143/255, alpha: 1.0)
        
        UITabBar.appearance().tintColor = color
        UITabBar.appearance().barTintColor = .black
        
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }



}

