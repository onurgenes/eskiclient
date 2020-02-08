//
//  OutsideLinkCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import SafariServices

final class OutsideLinkCoordinator: NSObject, Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    private var url: URL
    
    init(navigationController: UINavigationController, url: URL) {
        self.navigationController = navigationController
        self.url = url
        childCoordinators = []
    }
    
    func start() {
        let vm = OutsideLinkVM(url: url)
        let vc = OutsideLinkVC(url: url, configuration: SFSafariViewController.Configuration())
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.delegate = self
        navigationController.present(vc, animated: true)
    }
    
    func didClose() {
        parentCoordinator?.didFinish(coordinator: self)
    }
}

extension OutsideLinkCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        guard fromViewController is OutsideLinkVC else { return }
        parentCoordinator?.didFinish(coordinator: self)
    }
}
