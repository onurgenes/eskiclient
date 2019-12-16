//
//  SearchVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

protocol SearchVMProtocol: BaseVMProtocol {
    func search(query: String)
}

protocol SearchVMOutputProtocol: BaseVMOutputProtocol {
    func didSearch()
    func failedSearch(error: Error)
}

final class SearchVM: SearchVMProtocol {
    weak var delegate: SearchVMOutputProtocol?
    weak var coordinator: SearchCoordinator?
    private let networkManager: Networkable
    
    init(networkManager: Networkable) {
        self.networkManager = networkManager
    }
    var searchResult: SearchModel?
    
    func search(query: String) {
        networkManager.search(query: query) { result in
            switch result {
            case .failure(let error):
                self.delegate?.failedSearch(error: error)
            case .success(let value):
                self.searchResult = value
                self.delegate?.didSearch()
            }
        }
    }
}
