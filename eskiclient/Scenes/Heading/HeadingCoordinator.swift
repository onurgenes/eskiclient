//
//  HeadingCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class HeadingCoordinator: NSObject, Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    let url: String
    let isQuery: Bool
    let isComingFromHeading: Bool
    
    init(navigationController: UINavigationController, url: String, isQuery: Bool, isComingFromHeading: Bool) {
        self.navigationController = navigationController
        self.url = url
        self.isQuery = isQuery
        self.isComingFromHeading = isComingFromHeading
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let vm = HeadingVM(networkManager: networkManager, url: url, isQuery: isQuery, isComingFromHeading: isComingFromHeading)
        let vc = HeadingVC()
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openSelectedHeading(url: String, isQuery: Bool) {
        let coordinator = HeadingCoordinator(navigationController: navigationController, url: url, isQuery: isQuery, isComingFromHeading: true)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func openSelectedAuthor(name: String) {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        coordinator.otherProfileUserName = name
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func openAddEntry(newEntryModel: NewEntryModel) {
        let coordinator = AddEntryCoordinator(navigationController: navigationController, newEntryModel: newEntryModel)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func openEntry(number: String) {
        let coordinator = SingleEntryCoordinator(navigationController: navigationController, number: number)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func openOutsideLink(url: URL) {
        let coordinator = OutsideLinkCoordinator(navigationController: navigationController, url: url)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func finishedAddEntry(coordinator: Coordinator) {
        didFinish(coordinator: coordinator)
    }
}

extension HeadingCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        guard fromViewController is HeadingVC else { return }
        parentCoordinator?.didFinish(coordinator: self)
    }
}
