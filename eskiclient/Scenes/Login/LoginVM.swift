//
//  LoginVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

protocol LoginVMProtocol: BaseVMProtocol {
    
}

protocol LoginVMOutputProtocol: BaseVMOutputProtocol {
    
}

final class LoginVM: LoginVMProtocol {
    weak var delegate: LoginVMOutputProtocol?
    weak var coordinator: LoginCoordinator?
}
