//
//  LoginVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import WebKit
import FirebaseAnalytics

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
        
        if webView.url == URL(string: "https://eksisozluk.com/") {
            UIApplication.shared.beginIgnoringInteractionEvents()
            viewModel.finishLogin()
            navigationController?.popViewController(animated: true)
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
                CookieJar.save(cookies: cookies)
                DispatchQueue.main.async {
                    // ANALYTICS
                    Analytics.logEvent("userLoggedIn", parameters: ["userLoggedIn": true])
                    
                    NotificationCenter.default.post(name: .checkLoginNotificationName, object: nil, userInfo: nil)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        } 
    }
}
