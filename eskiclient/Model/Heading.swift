//
//  Heading.swift
//  eskiclient
//
//  Created by Onur Geneş on 20.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

final class Heading {
    let name: String?
    let count: String?
    let link: String?
    
    init(name: String?, count: String?, link: String?) {
        self.name = name
        self.count = count
        self.link = link
    }
}
