//
//  TabBarVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 17.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation
import Kanna

protocol TabBarVMProtocol: AnyObject {
    var delegate: TabBarVMOutputProtocol? { get set }
    
}

protocol TabBarVMOutputProtocol: AnyObject {
    func didCheckLoggedIn()
    func failedCheckLoggedIn()
}

final class TabBarVM: TabBarVMProtocol {
    weak var delegate: TabBarVMOutputProtocol?
    weak var coordinator: TabBarCoordinator?
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}
