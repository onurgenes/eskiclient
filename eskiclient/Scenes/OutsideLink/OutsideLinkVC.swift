//
//  OutsideLinkVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import WebKit

final class OutsideLinkVC: BaseVC<OutsideLinkVM, WKWebView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.load(URLRequest(url: viewModel.url))
        baseView.allowsBackForwardNavigationGestures = true
    }
}
