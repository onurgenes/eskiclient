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
    
    let tabBarVC = TabBarVC()
    
    init() {
        navigationController = UINavigationController()
        childCoordinators = []
        NotificationCenter.default.addObserver(self, selector: #selector(onReceivedLogin), name: .loginNotificationName, object: nil)
    }
    
    @objc func onReceivedLogin(_ notification:Notification) {
        if let data = notification.userInfo as? [String: Bool], let isLoggedIn = data["isLoggedIn"] {
            if isLoggedIn {
                addProfile()
            } else {
                removeProfile()
            }
        }
    }
    
    func start() {
        let homeNavController = CustomNavController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavController)
        homeCoordinator.parentCoordinator = self
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
        
        let searchNavController = CustomNavController()
        let searchCoordinator = SearchCoordinator(navigationController: searchNavController)
        searchCoordinator.parentCoordinator = self
        childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
        
        let settingsNavController = CustomNavController()
        let settingsCoordinator = SettingsCoordinator(navigationController: settingsNavController)
        settingsCoordinator.parentCoordinator = self
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
        
        let tabBarNetworkManager = NetworkManager()
        let tabBarVM = TabBarVM(networkManager: tabBarNetworkManager)
        tabBarVC.viewModel = tabBarVM
        tabBarVC.viewControllers = [homeCoordinator.navigationController,
                                    searchCoordinator.navigationController,
                                    settingsCoordinator.navigationController]
        
        app.window.rootViewController = tabBarVC
    }
    
    private func addProfile() {
        if tabBarVC.viewControllers!.contains(where: { ($0 as! UINavigationController).viewControllers.first is ProfileVC }) {
            return
        }
        let profileNavController = CustomNavController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavController)
        profileCoordinator.parentCoordinator = self
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
        
        tabBarVC.viewControllers?.append(profileNavController)
    }
    
    private func removeProfile() {
        tabBarVC.viewControllers = tabBarVC.viewControllers?.filter{ !($0 is ProfileVC) }
    }
}
