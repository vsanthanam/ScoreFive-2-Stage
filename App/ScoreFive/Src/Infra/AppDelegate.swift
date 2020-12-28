//
//  AppDelegate.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/25/20.
//

import CoreData
import UIKit
import NeedleFoundation
import ShortRibs

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerProviderFactories()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        .init(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - API

    lazy var persistentContainer: PersistentContaining  = {
        guard let url = Bundle.main.url(forResource: "ScoreFive", withExtension: "momd") else {
            fatalError("Missing persistent storage data model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to create model from url")
        }
        let container = NSPersistentContainer(name: "ScoreFive", managedObjectModel: managedObjectModel)
        let persistentContainer = PersistentContainer(container)
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError()
            }
        }
        return persistentContainer
    }()
}
