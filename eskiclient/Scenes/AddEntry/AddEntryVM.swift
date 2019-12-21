//
//  AddEntryVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 21.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

protocol AddEntryVMProtocol: BaseVMProtocol {
    
}

protocol AddEntryVMOutputProtocol: BaseVMOutputProtocol {
    
}

final class AddEntryVM: AddEntryVMProtocol {
    weak var delegate: AddEntryVMOutputProtocol?
    weak var coordinator: AddEntryCoordinator?
    
    private let networkManager: Networkable
    private let newEntryModel: NewEntryModel
    
    init(networkManager: Networkable, newEntryModel: NewEntryModel) {
        self.networkManager = networkManager
        self.newEntryModel = newEntryModel
    }
    
    
}
