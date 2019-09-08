//
//  BaseVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

class BaseVC<VM: BaseVMProtocol, V: UIView>: UIViewController {
    let baseView = V()
    override func loadView() { view = baseView }
    var viewModel: VM! {
        didSet {
            viewModel.delegate = self as? VM.OutputProtocol
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self as? VM.OutputProtocol
    }
}

extension BaseVC: BaseVMOutputProtocol { }
