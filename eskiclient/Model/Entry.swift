//
//  Entry.swift
//  eskiclient
//
//  Created by Onur Geneş on 20.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation

final class Entry: NSObject {
    let content: NSAttributedString
    let author: String
    let date: String
    let favoritesCount: String
    let isFavorited: Bool
    let entryId: String
    let authorId: String
    
    init(content: NSAttributedString, author: String, date: String, favoritesCount: String, entryId: String, authorId: String, isFavorited: Bool) {
        self.content = content
        self.author = author
        self.date = date
        self.favoritesCount = favoritesCount
        self.isFavorited = isFavorited
        self.entryId = entryId
        self.authorId = authorId
    }
}
