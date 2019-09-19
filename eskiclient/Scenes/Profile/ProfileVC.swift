//
//  ProfileVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 18.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class ProfileVC: BaseVC<ProfileVM, ProfileView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let username = UserDefaults.standard.string(forKey: "currentUsername") {
            viewModel.getProfile(username: username)
        }
    }
}

extension ProfileVC: ProfileVMOutputProtocol {
    func didGetProfile() {
        
    }
    
    func failedGetProfile() {
        
    }
}
