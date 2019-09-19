//
//  ProfileCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 18.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    let networkManager: NetworkManager
    
    init(navigationController: UINavigationController, networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let profileVM = ProfileVM(networkManager: networkManager)
        let profileVC = ProfileVC()
        profileVC.title = "profile"
        profileVC.viewModel = profileVM
        profileVM.coordinator = self
        navigationController.pushViewController(profileVC, animated: true)
    }
}
