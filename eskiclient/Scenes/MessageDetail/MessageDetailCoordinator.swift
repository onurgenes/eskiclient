//
//  MessageDetailCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import UIKit

final class MessageDetailCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    let url: String
    
    init(navigationController: UINavigationController, url: String) {
        self.navigationController = navigationController
        self.url = url
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let vm = MessageDetailVM(networkManager: networkManager, url: url)
        let vc = MessageDetailVC()
        vc.title = "mesajlar"
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

