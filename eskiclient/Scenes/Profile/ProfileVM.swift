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
    func failedGetProfile(error: Error)
}

final class ProfileVM: ProfileVMProtocol {
    weak var delegate: ProfileVMOutputProtocol?
    weak var coordinator: ProfileCoordinator?
    let networkManager: NetworkManager
    
    var otherProfileUsername: String?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    private(set) var userHeadings = [UserHeading]()
    
    func getProfile(username: String) {
        networkManager.getLatestEntries(username: username) { result in
            switch result {
            case .failure(let error):
                self.delegate?.failedGetProfile(error: error)
            case .success(let val):
                self.userHeadings.removeAll()
                do {
                    let doc = try HTML(html: val, encoding: .utf8)
                    for baslik in doc.xpath("//*[@id='content-body']/ul/li/a") {
                        let text = baslik.xpath("text()[1]").first?.content?.trimmingCharacters(in: .whitespacesAndNewlines)
                        let link = baslik["href"]
                        let entryNumber = baslik.xpath("span/text()").first?.content
                        let heading = UserHeading(text: text, link: link, entryNumber: entryNumber)
                        self.userHeadings.append(heading)
                        self.delegate?.didGetProfile()
                    }
                } catch {
                    self.delegate?.failedGetProfile(error: error)
                }
            }
        }
    }
}
