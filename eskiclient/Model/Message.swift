//
//  Message.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import Foundation

final class Message {
    let threadId: String?
    let senderUsername: String?
    let content: String?
    let date: String?
    let url: String?
    
    internal init(threadId: String?, senderUsername: String?, content: String?, date: String?, url: String?) {
        self.threadId = threadId
        self.senderUsername = senderUsername
        self.content = content
        self.date = date
        self.url = url
    }
}
