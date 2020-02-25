//
//  AppCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

let app = AppCoordinator()

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    let window: UIWindow
    
    init() {
        window = UIWindow()
        childCoordinators = []
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        if !UserDefaults.standard.bool(forKey: "launchedBefore") {
            UserDefaults.standard.set(true, forKey: "isAdsAllowed")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.parentCoordinator = self
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
//        if UserDefaults.standard.bool(forKey: "launchedBefore") {
//            let tabBarCoordinator = TabBarCoordinator()
//            tabBarCoordinator.parentCoordinator = self
//            childCoordinators.append(tabBarCoordinator)
//            tabBarCoordinator.start()
//            return
//        }
//        UserDefaults.standard.set(true, forKey: "isAdsAllowed")
//        UserDefaults.standard.set(true, forKey: "launchedBefore")
//        startOnboarding()
    }
    
    func startOnboarding() {
        let onboardCoordinator = OnboardCoordinator(navigationController: CustomNavController())
        onboardCoordinator.parentCoordinator = self
        childCoordinators.append(onboardCoordinator)
        onboardCoordinator.start()
        window.rootViewController = onboardCoordinator.navigationController
    }
}
