//
//  ProfileVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 18.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation
import Kanna

protocol ProfileVMProtocol: BaseVMProtocol {
    func getProfile(username: String)
}

protocol ProfileVMOutputProtocol: BaseVMOutputProtocol {
    func didGetProfile()
    func failedGetProfile()
}

final class ProfileVM: ProfileVMProtocol {
    weak var delegate: ProfileVMOutputProtocol?
    weak var coordinator: ProfileCoordinator?
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getProfile(username: String) {
        networkManager.getMe(username: username) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let val):
                do {
                    let doc = try HTML(html: val, encoding: .utf8)
                    if let username = doc.xpath("//*[@id='user-profile-title']/a").first?.content {
                        print(username)
                    }
                    let topics = doc.xpath("//*[@id='title']")
                    for topic in topics {
                        print(topic)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
