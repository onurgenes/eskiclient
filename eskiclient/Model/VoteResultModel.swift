//
//  VoteResultModel.swift
//  eskiclient
//
//  Created by Onur Geneş on 24.01.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import Foundation

final class VoteResultModel: Codable {
    let alreadyVotedAnonymously: Bool?
    let message: String?
    let success: Bool?

    enum CodingKeys: String, CodingKey {
        case alreadyVotedAnonymously = "AlreadyVotedAnonymously"
        case message = "Message"
        case success = "Success"
    }

    init(alreadyVotedAnonymously: Bool?, message: String?, success: Bool?) {
        self.alreadyVotedAnonymously = alreadyVotedAnonymously
        self.message = message
        self.success = success
    }
}
