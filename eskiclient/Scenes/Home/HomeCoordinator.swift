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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let vm = HomeVM(networkManager: networkManager)
        let vc = HomeVC()
        vc.title = "eşki"
        vc.tabBarItem.image = UIImage.fontAwesomeIcon(name: .lemon, style: .solid, textColor: .white, size: CGSize(width: 32, height: 32))
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openHeading(url: String) {
        let headingCoordinator = HeadingCoordinator(navigationController: navigationController, url: url, isQuery: false)
        headingCoordinator.parentCoordinator = self
        childCoordinators.append(headingCoordinator)
        headingCoordinator.start()
    }
    
    func openLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.parentCoordinator = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
}
