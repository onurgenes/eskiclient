//
//  FavResultModel.swift
//  eskiclient
//
//  Created by Onur Geneş on 23.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import Foundation

// MARK: - FavResultModel
class FavResultModel: Codable {
    let success: Bool?
    let errorMessage: String?
    let count: Int?

    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case errorMessage = "ErrorMessage"
        case count = "Count"
    }

    init(success: Bool?, errorMessage: String?, count: Int?) {
        self.success = success
        self.errorMessage = errorMessage
        self.count = count
    }
}

