//
//  CustomNavController.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.tintColor = R.color.themeMain()
    }

}
