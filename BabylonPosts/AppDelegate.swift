//
//  AppDelegate.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    var mainFlowCoordinator: MainFlowCoordinator?
    
    lazy var disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard let window = window else {
            fatalError("AppDelegate is missing UIWindow")
        }
        
        struct AppDependencies: MainFlowCoordinator.Dependencies {
            
            var storage: StorageType {
                return RealmPersistantStorage()
            }
            
            var apiClient: ApiClientType {
                return JSONPlaceholderApiClient.init(networking: sharedNetworking)
            }
            
            var dataProvider: DataProviderType {
                return DataProvider(apiClient: apiClient, storage: storage)
            }
            
            var comments: CommentsProviderType {
                return dataProvider.comments
            }
            
            var users: UsersProviderType {
                return dataProvider.users
            }
            
            let sharedNetworking: NetworkingType = {
                // Use ephemeral config in order to avoid url cache
                let sessionManager = SessionManager(configuration: URLSessionConfiguration.ephemeral)
                let networking = Networking(manager: sessionManager)
                return networking
            }()
        }
        
        let appDependencies = AppDependencies()
        appDependencies.sharedNetworking.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(application.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        let flowCoordinator = MainFlowCoordinator(window: window, dependencies: appDependencies)
        flowCoordinator.loadRootViewController()
        mainFlowCoordinator = flowCoordinator
        
        return true
    }
}
