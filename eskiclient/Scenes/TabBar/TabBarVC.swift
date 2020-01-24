//
//  TabBarVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 15.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class TabBarVC: UITabBarController {
    
    var viewModel: TabBarVMProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = R.color.themeMain()
    }
    
}

extension TabBarVC: TabBarVMOutputProtocol {
    func didCheckLoggedIn() {
        // TODO: Do some magic because user is logged in
    }
    
    func failedCheckLoggedIn() {
        // TODO: Remove controller because user is not logged in!
    }
}
