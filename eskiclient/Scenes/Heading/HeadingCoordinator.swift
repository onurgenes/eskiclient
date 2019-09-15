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
    var url: String
    
    init(navigationController: UINavigationController, url: String) {
        self.navigationController = navigationController
        self.url = url
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let vm = HeadingVM(networkManager: networkManager, url: url)
        let vc = HeadingVC()
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
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
