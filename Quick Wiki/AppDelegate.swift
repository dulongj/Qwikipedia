//
//  AppDelegate.swift
//  Quick Wiki
//
//  Created by Jeremy Dulong on 11/22/16.
//  Copyright © 2016 1500 Fahrenheit. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Launch Screen Gif Display
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor(red:0.09, green:0.10, blue:0.11, alpha:1.0)
        let imageView = UIImageView(frame: self.window!.frame)
        imageView.loadGif(name: "fireanimation_portrait")
        imageView.alpha = 0.0
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        self.window!.addSubview(imageView)
        let emptyView = UIViewController()
        self.window?.rootViewController = emptyView
        self.window!.makeKeyAndVisible()
        UIView.animate(withDuration: 1.5, animations: {imageView.alpha = 1}, completion: { (value: Bool) in UIView.animate(withDuration: 1.0, animations: {sleep(UInt32(1.5))}, completion: { (value: Bool) in UIView.animate(withDuration: 2.0, animations: {imageView.alpha = 0}, completion: { (value: Bool) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as UIViewController
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        })})})
        UIApplication.shared.isStatusBarHidden = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Quick_Wiki")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

