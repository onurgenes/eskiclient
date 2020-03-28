//
//  SettingsCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 24.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let settingsVM = SettingsVM()
        let settingsVC = SettingsVC()
        settingsVC.viewModel = settingsVM
        settingsVM.coordinator = self
        settingsVC.title = "ayarlar"
        settingsVC.tabBarItem.image = UIImage.fontAwesomeIcon(name: .cogs, style: .solid, textColor: .white, size: CGSize(width: 32, height: 32))
        navigationController.pushViewController(settingsVC, animated: false)
    }
    
    func openEskiHeading() {
        let headingCoordinator = HeadingCoordinator(navigationController: navigationController, url: "eskisozluk-client--6329236", isQuery: false, isComingFromHeading: true)
        headingCoordinator.parentCoordinator = self
        childCoordinators.append(headingCoordinator)
        headingCoordinator.start()
    }
}
