//
//  MessageDetail.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import Foundation

final class MessageDetail {
    let isIncoming: Bool?
    let content: String?
    let senderUsername: String?
    let date: String?
    
    internal init(isIncoming: Bool?, content: String?, senderUsername: String?, date: String?) {
        self.isIncoming = isIncoming
        self.content = content
        self.senderUsername = senderUsername
        self.date = date
    }
}
