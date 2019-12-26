//
//  OnboardVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

protocol OnboardVMProtocol: BaseVMProtocol {
    
}

protocol OnboardVMOutputProtocol: BaseVMOutputProtocol {
    
}

final class OnboardVM: OnboardVMProtocol {
    weak var delegate: OnboardVMOutputProtocol?
    weak var coordinator: OnboardCoordinator?
    
    let networkManager: Networkable
    
    init(networkManager: Networkable) {
        self.networkManager = networkManager
    }
    
}
