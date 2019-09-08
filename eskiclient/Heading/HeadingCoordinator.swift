//
//  HeadingCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class HeadingCoordinator: Coordinator {
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
        navigationController.pushViewController(vc, animated: true)
    }
}
