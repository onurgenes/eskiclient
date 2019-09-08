//
//  HomeCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class HomeCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    var networkManager: NetworkManager
    
    init(navigationController: UINavigationController, networkManager: NetworkManager) {
        self.navigationController = navigationController
        self.networkManager = networkManager
        childCoordinators = []
    }
    
    func start() {
        let vm = HomeVM(networkManager: networkManager)
        let vc = HomeVC()
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openHeading(url: String) {
        let headingCoordinator = HeadingCoordinator(navigationController: navigationController, url: url)
        headingCoordinator.parentCoordinator = self
        childCoordinators.append(headingCoordinator)
        headingCoordinator.start()
    }
}
