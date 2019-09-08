//
//  Coordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func didFinish(coordinator: Coordinator)
}

extension Coordinator {
    func didFinish(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter{ $0 !== coordinator }
    }
}
