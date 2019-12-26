//
//  OutsideLinkVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

protocol OutsideLinkVMProtocol: BaseVMProtocol {
    
}

protocol OutsideLinkVMOutputProtocol: BaseVMOutputProtocol {
    
}

final class OutsideLinkVM: OutsideLinkVMProtocol {
    weak var delegate: OutsideLinkVMOutputProtocol?
    weak var coordinator: OutsideLinkCoordinator?
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}
