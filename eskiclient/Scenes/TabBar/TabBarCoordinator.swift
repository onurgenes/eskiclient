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
        NotificationCenter.default.addObserver(self, selector: #selector(onReceivedLogOut(_:)), name: .loggedOutNotificationName, object: nil)
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
    
    @objc func onReceivedLogOut(_ notification:Notification) {
        tabBarVC.selectedIndex = 0
        removeProfile()
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
        
        let messageNavController = CustomNavController()
        let messageCoordinator = MessageCoordinator(navigationController: messageNavController)
        messageCoordinator.parentCoordinator = self
        childCoordinators.append(messageCoordinator)
        messageCoordinator.start()
        
        tabBarVC.viewControllers?.insert(messageNavController, at: 2)
        
        let profileNavController = CustomNavController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavController)
        profileCoordinator.parentCoordinator = self
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
        
        tabBarVC.viewControllers?.insert(profileNavController, at: 3)
    }
    
    private func removeProfile() {
        tabBarVC.viewControllers = tabBarVC.viewControllers?.filter{
            !(($0 as! UINavigationController).viewControllers.first is ProfileVC ||
            ($0 as! UINavigationController).viewControllers.first is MessageVC)
        }
    }
}
