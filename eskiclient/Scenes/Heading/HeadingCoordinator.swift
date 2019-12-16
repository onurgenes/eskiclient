//
//  HeadingCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class HeadingCoordinator: NSObject, Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    let url: String
    let isQuery: Bool
    
    init(navigationController: UINavigationController, url: String, isQuery: Bool) {
        self.navigationController = navigationController
        self.url = url
        self.isQuery = isQuery
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let vm = HeadingVM(networkManager: networkManager, url: url, isQuery: isQuery)
        let vc = HeadingVC()
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
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

extension HeadingCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        guard fromViewController is HeadingVC else { return }
        parentCoordinator?.didFinish(coordinator: self)
    }
}
