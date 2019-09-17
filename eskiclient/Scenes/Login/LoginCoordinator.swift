//
//  LoginCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class LoginCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let loginVM = LoginVM()
        let loginVC = LoginVC()
        loginVC.viewModel = loginVM
        loginVM.coordinator = self
        navigationController.pushViewController(loginVC, animated: true)
    }
}
