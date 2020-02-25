//
//  OnboardPages.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

enum OnboardPages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
    case pageThree
    
    var view: UIView {
        switch self {
        case .pageZero:
            return UIView()
        case .pageOne:
            return UIView()
        case .pageTwo:
            return UIView()
        case .pageThree:
            return UIView()
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        case .pageThree:
            return 3
        }
    }
}
