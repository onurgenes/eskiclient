//
//  OutsideLinkVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import SafariServices

final class OutsideLinkVC: SFSafariViewController {
    
    var viewModel: OutsideLinkVM! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override init(url URL: URL, configuration: SFSafariViewController.Configuration) {
        super.init(url: URL, configuration: configuration)
        
        self.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
    }
}

extension OutsideLinkVC: OutsideLinkVMOutputProtocol {
    
}

extension OutsideLinkVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = false
        viewModel.didClose()
    }
}
