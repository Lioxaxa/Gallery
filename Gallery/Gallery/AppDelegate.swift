//
//  AppDelegate.swift
//  Gallery
//
//  Created by Pupko, Aleksey on 8.01.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navc = UINavigationController(rootViewController: GalleryViewController())
        window = UIWindow()
        window?.rootViewController = navc
        window?.makeKeyAndVisible()
        return true
    }

}

