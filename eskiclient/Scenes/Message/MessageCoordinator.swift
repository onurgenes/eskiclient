//
//  MessageCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import UIKit

final class MessageCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let vm = MessageVM(networkManager: networkManager)
        let vc = MessageVC()
        vc.title = "mesajlar"
        vc.tabBarItem.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .white, size: CGSize(width: 32, height: 32))
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openMessageDetail(url: String) {
        let messageDetailCoordinator = MessageDetailCoordinator(navigationController: navigationController, url: url)
        messageDetailCoordinator.parentCoordinator = self
        childCoordinators.append(messageDetailCoordinator)
        messageDetailCoordinator.start()
    }
}
