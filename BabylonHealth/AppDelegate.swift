//
//  AppDelegate.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    var mainFlowCoordinator: MainFlowCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard let window = window else {
            fatalError("AppDelegate is missing UIWindow")
        }
        
        struct AppDependencies: MainFlowCoordinator.Dependencies {
            var storage: PersistentStorage {
                return RealmPersistantStorage()
            }
            
            var apiClient: ApiClient {
//                return MockApiClient()
                
                // Use ephemeral config in order to avoid url cache
                let sessionManager = SessionManager(configuration: URLSessionConfiguration.ephemeral)
                let networking = Networking(manager: sessionManager)
                return JSONPlaceholderApiClient.init(networking: networking)
            }
        }
        
        let appDependencies = AppDependencies()
        let flowCoordinator = MainFlowCoordinator(window: window, dependencies: appDependencies)
        flowCoordinator.loadRootViewController()
        mainFlowCoordinator = flowCoordinator
        
        return true
    }

}

