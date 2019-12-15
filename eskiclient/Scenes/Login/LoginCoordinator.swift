//
//  LoginCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class LoginCoordinator: NSObject, Coordinator {
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
        navigationController.delegate = self
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func finishLogin() {
        parentCoordinator?.didFinish(coordinator: self)
    }
}

extension LoginCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        guard fromViewController is LoginVC else { return }
        parentCoordinator?.didFinish(coordinator: self)
    }
}
