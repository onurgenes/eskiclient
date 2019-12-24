//
//  SingleEntryCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 24.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import ContextMenu

final class SingleEntryCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    let number: String
    
    init(navigationController: UINavigationController, number: String) {
        self.navigationController = navigationController
        self.number = number
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let singleEntryVM = SingleEntryVM(networkManager: networkManager, number: number)
        let singleEntryVC = SingleEntryVC()
        singleEntryVM.coordinator = self
        singleEntryVC.viewModel = singleEntryVM
        ContextMenu.shared.show(sourceViewController: navigationController,
                                viewController: singleEntryVC,
                                options: ContextMenu.Options(menuStyle: .minimal),
                                sourceView: nil,
                                delegate:self)
    }
}

extension SingleEntryCoordinator: ContextMenuDelegate {
    func contextMenuWillDismiss(viewController: UIViewController, animated: Bool) {
        
    }
    
    func contextMenuDidDismiss(viewController: UIViewController, animated: Bool) {
        (parentCoordinator as? HeadingCoordinator)?.finishedAddEntry(coordinator: self)
    }
}
