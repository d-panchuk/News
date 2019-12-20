//
//  AppCoordinator.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    let window: UIWindow?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var onFinish: (() -> Void)?
    
    init(window: UIWindow?) {
        self.window = window
        self.presenter = UINavigationController()
        self.childCoordinators = []
    }
    
    func start() {
        let feedCoordinator = NewsFeed.ScreenCoordinator(presenter: presenter)
        addDependency(feedCoordinator)
        feedCoordinator.start()
        
        window?.rootViewController = presenter
        window?.makeKeyAndVisible()
    }

}
