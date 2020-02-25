//
//  OnboardCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class OnboardCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let vm = OnboardVM(networkManager: networkManager)
        let vc = OnboardVC()
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func finish() {
        app.start()
    }
}
