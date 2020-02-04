//
//  OutsideLinkVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import WebKit

final class OutsideLinkVC: BaseVC<OutsideLinkVM, OutsideLinkView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.webView.load(URLRequest(url: viewModel.url))
        baseView.webView.allowsBackForwardNavigationGestures = true
        baseView.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            baseView.progressView.progress = Float(baseView.webView.estimatedProgress)
        }
    }
}
