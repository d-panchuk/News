//
//  AppDelegate.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startApplicationWithCoordinator()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
    
}

// MARK: - Application start
private extension AppDelegate {
    
    func startApplicationWithCoordinator() {
        #if DEBUG
        setupRxResourceLogging()
        #endif
        
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppCoordinator(window: window)
        coordinator?.start()
    }
    
    func setupRxResourceLogging() {
        _ = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { _ in
//                print("RxSwift resources count: \(RxSwift.Resources.total).")
        }
    }
    
}
