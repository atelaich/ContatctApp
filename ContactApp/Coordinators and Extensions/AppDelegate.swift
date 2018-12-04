//
//  AppDelegate.swift
//  ContactApp
//
//  Created by Anil Telaich on 28/11/18.
//  Copyright © 2018 Anil Telaich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    fileprivate let kSplitWidth : CGFloat = CGFloat(100)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let deviceOrientation = UIDevice.current.orientation
        if let masterDetailSplitViewController = MasterDetailSplitViewController(splitType: deviceOrientation == .landscapeLeft || deviceOrientation == .landscapeRight ? .Horizontal : .Vertical, splitWidth: kSplitWidth) {
            window!.rootViewController = UINavigationController(rootViewController: masterDetailSplitViewController)
        }
        else {
           print("Failed to initialize home screen.")
        }
        
        return true
    }
}

