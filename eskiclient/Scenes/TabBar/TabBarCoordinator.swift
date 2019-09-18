//
//  TabBarCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 15.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init() {
        navigationController = UINavigationController()
        childCoordinators = []
    }
    
    func start() {
        let homeNavController = UINavigationController()
        let homeNetworkManager = NetworkManager()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavController, networkManager: homeNetworkManager)
        homeCoordinator.parentCoordinator = self
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
        
        let profileNavController = UINavigationController()
        let profileNetworkManager = NetworkManager()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavController, networkManager: profileNetworkManager)
        profileCoordinator.parentCoordinator = self
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
        
        let tabBarNetworkManager = NetworkManager()
        let tabBarVM = TabBarVM(networkManager: tabBarNetworkManager)
        let tabBarVC = TabBarVC()
        tabBarVC.viewModel = tabBarVM
        tabBarVC.viewControllers = [homeNavController, profileNavController]
        app.window.rootViewController = tabBarVC
    }
}
