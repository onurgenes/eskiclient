//
//  AddEntryVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 21.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

protocol AddEntryVMProtocol: BaseVMProtocol {
    func sendEntry(text: String)
}

protocol AddEntryVMOutputProtocol: BaseVMOutputProtocol {
    func failedSendEntry(error: Error)
    func didSendEntry()
}

final class AddEntryVM: AddEntryVMProtocol {
    weak var delegate: AddEntryVMOutputProtocol?
    weak var coordinator: AddEntryCoordinator?
    
    private let networkManager: Networkable
    var newEntryModel: NewEntryModel
    
    init(networkManager: Networkable, newEntryModel: NewEntryModel) {
        self.networkManager = networkManager
        self.newEntryModel = newEntryModel
    }
    
    func sendEntry(text: String) {
        
        newEntryModel.text = text
        
        networkManager.sendEntry(model: newEntryModel) { result in
            switch result {
            case .failure(let error):
                self.delegate?.failedSendEntry(error: error)
            case .success(_):
                self.delegate?.didSendEntry()
            }
        }
    }
}
