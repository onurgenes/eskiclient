//
//  SearchModel.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

// MARK: - SearchModel
class SearchModel: Codable {
    let titles: [String]?
    let query: String?
    let nicks: [String]?

    enum CodingKeys: String, CodingKey {
        case titles = "Titles"
        case query = "Query"
        case nicks = "Nicks"
    }

    init(titles: [String]?, query: String?, nicks: [String]?) {
        self.titles = titles
        self.query = query
        self.nicks = nicks
    }
}

