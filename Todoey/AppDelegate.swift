//
//  AppDelegate.swift
//  Todoey
//
//  Created by Nafea Elkassas on 15/09/2023.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        print (Realm.Configuration.defaultConfiguration.fileURL)

        do{
            _ = try Realm()

        } catch{
            print("error in initialising new realm \(error)")
        }
                return true
    }


    
}

