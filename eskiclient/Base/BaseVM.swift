//
//  BaseVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

protocol BaseVMOutputProtocol: AnyObject { }

protocol BaseVMProtocol: AnyObject {
    associatedtype OutputProtocol
    var delegate: OutputProtocol? { get set }
}
