//
//  OnboardPageVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

class OnboardPageVC: UIViewController {
    
    var page: OnboardPages
    let onboardView: UIView
    
    init(with page: OnboardPages, onboardView: UIView) {
        self.page = page
        self.onboardView = onboardView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
