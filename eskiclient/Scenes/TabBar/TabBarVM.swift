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
    
    func checkLoggedIn()
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
    
    func checkLoggedIn() {
        networkManager.getLanding { result in
            switch result {
            case .failure(_):
                self.delegate?.failedCheckLoggedIn()
            case .success(let val):
                do {
                    let doc = try HTML(html: val, encoding: .utf8)
                    let loggedInTag = doc.xpath("//*[@id='top-login-link']").first?.content
                    let isLoggedIn = loggedInTag != nil ? false : true
                    UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
                    self.delegate?.didCheckLoggedIn()
                } catch {
                    self.delegate?.failedCheckLoggedIn()
                }
            }
        }
    }
}
