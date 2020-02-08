//
//  LoginVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import WebKit

final class LoginVC: BaseVC<LoginVM, LoginView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.webView.navigationDelegate = self
        let url = URL(string: "https://eksisozluk.com/giris")!
        let urlRequest = URLRequest(url: url)
        baseView.webView.load(urlRequest)
    }
}

extension LoginVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
            CookieJar.save(cookies: cookies)
        }
        
        if webView.url == URL(string: "https://eksisozluk.com/") {
            viewModel.finishLogin()
            navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: .loginNotificationName, object: nil, userInfo: ["isLoggedIn": true])
        }
    }
}
