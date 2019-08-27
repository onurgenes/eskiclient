//
//  AppCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

let app = AppCoordinator()

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    let window: UIWindow
    
    init() {
        window = UIWindow()
        childCoordinators = []
        navigationController = UINavigationController(rootViewController: HomePageVC())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        
    }
}
