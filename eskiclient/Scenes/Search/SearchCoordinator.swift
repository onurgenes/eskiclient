//
//  SearchCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let searchVM = SearchVM(networkManager: networkManager)
        let searchVC = SearchVC()
        searchVC.title = "ara"
        searchVC.tabBarItem.image = UIImage.fontAwesomeIcon(name: .search, style: .solid, textColor: .white, size: CGSize(width: 32, height: 32))
        searchVC.viewModel = searchVM
        searchVM.coordinator = self
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func openSelectedHeading(url: String, isQuery: Bool) {
        let coordinator = HeadingCoordinator(navigationController: navigationController, url: url, isQuery: isQuery)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func openSelectedAuthor(name: String) {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        coordinator.otherProfileUserName = name
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}
