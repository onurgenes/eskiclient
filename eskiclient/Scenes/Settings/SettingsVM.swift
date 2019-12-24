//
//  SettingsVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 24.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

protocol SettingsVMProtocol: BaseVMProtocol {
    
}

protocol SettingsVMOutputProtocol: BaseVMOutputProtocol {
    
}

final class SettingsVM: SettingsVMProtocol {
    weak var delegate: SettingsVMOutputProtocol?
    weak var coordinator: SettingsCoordinator?
    
    init() {
        
    }
    
    
}
