//
//  Collection+Safe.swift
//  eskiclient
//
//  Created by Onur Geneş on 20.03.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import Foundation

extension Collection {
    public subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
