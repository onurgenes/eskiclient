//
//  ProfileVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 18.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

protocol ProfileVMProtocol: BaseVMProtocol {
    
}

protocol ProfileVMOutputProtocol: BaseVMOutputProtocol {
    
}

final class ProfileVM: BaseVMProtocol {
    weak var delegate: ProfileVMOutputProtocol?
    weak var coordinator: ProfileCoordinator?
}
