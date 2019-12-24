//
//  ProfileCoordinator.swift
//  eskiclient
//
//  Created by Onur Geneş on 18.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    var otherProfileUserName: String?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let networkManager = NetworkManager()
        let profileVM = ProfileVM(networkManager: networkManager)
        let profileVC = ProfileVC()
        profileVC.title = "profil"
        profileVC.tabBarItem.image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: .white, size: CGSize(width: 32, height: 32))
        profileVC.viewModel = profileVM
        profileVM.coordinator = self
        profileVM.otherProfileUsername = otherProfileUserName
        navigationController.pushViewController(profileVC, animated: true)
    }
}
