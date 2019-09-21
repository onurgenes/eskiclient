//
//  HomeVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation
import Kanna

protocol HomeVMProtocol: BaseVMProtocol {
    func getHomepage(number: Int)
}

protocol HomeVMOutputProtocol: BaseVMOutputProtocol {
    func didGetHomepage()
    func failedGetHomepage(error: Error)
}

final class HomeVM: HomeVMProtocol {
    weak var delegate: HomeVMOutputProtocol?
    weak var coordinator: HomeCoordinator?
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    private(set) var headings = [Heading]()
    
    func getHomepage(number: Int) {
        networkManager.getHomePage(number: number) { result in
            switch result {
            case .failure(let err):
                self.delegate?.failedGetHomepage(error: err)
            case .success(let val):
                do {
                    self.headings.removeAll()
                    
                    let doc = try HTML(html: val, encoding: .utf8)
                    for headingData in doc.xpath("//*[@id='content-body']/ul/li/a") {
                        let heading = Heading(name: headingData.xpath("text()[1]").first?.text?.trimmingCharacters(in: .whitespaces),
                                              count: headingData.xpath("small/text()[1]").first?.text?.trimmingCharacters(in: .whitespaces),
                                              link: headingData["href"])
                        self.headings.append(heading)
                    }
                    self.delegate?.didGetHomepage()
                } catch {
                    self.delegate?.failedGetHomepage(error: error)
                }
            }
        }
    }
    
    
    func openHeading(url: String) {
        coordinator?.openHeading(url: url)
    }
    
    func openLogin() {
        coordinator?.openLogin()
    }
}
