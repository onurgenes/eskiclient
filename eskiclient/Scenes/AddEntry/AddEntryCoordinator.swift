//
//  AddEntryCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 21.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import ContextMenu

final class AddEntryCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    let newEntryModel: NewEntryModel
    
    init(navigationController: UINavigationController, newEntryModel: NewEntryModel) {
        self.navigationController = navigationController
        self.newEntryModel = newEntryModel
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let addEntryVM = AddEntryVM(networkManager: networkManager, newEntryModel: newEntryModel)
        let addEntryVC = AddEntryVC()
        addEntryVC.title = "entry gir"
        addEntryVM.coordinator = self
        addEntryVC.viewModel = addEntryVM
        ContextMenu.shared.show(sourceViewController: navigationController,
                                viewController: addEntryVC,
                                delegate: self)
    }
}

extension AddEntryCoordinator: ContextMenuDelegate {
    func contextMenuWillDismiss(viewController: UIViewController, animated: Bool) {
        
    }
    
    func contextMenuDidDismiss(viewController: UIViewController, animated: Bool) {
        
    }
}
