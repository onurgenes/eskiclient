//
//  SingleEntryVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 24.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation
import Kanna

protocol SingleEntryVMProtocol: BaseVMProtocol {
    func getSingleEntry()
}

protocol SingleEntryVMOutputProtocol: BaseVMOutputProtocol {
    func didGetSingleEntry()
    func failedGetSingleEntry(error: Error)
}

final class SingleEntryVM: SingleEntryVMProtocol {
    weak var delegate: SingleEntryVMOutputProtocol?
    weak var coordinator: SingleEntryCoordinator?
    
    private let networkManager: Networkable
    var number: String
    var entry: Entry?
    
    init(networkManager: Networkable, number: String) {
        self.networkManager = networkManager
        self.number = number
    }
    
    func getSingleEntry() {
        networkManager.getEntry(number: number) { result in
            switch result {
            case .failure(let error):
                self.delegate?.failedGetSingleEntry(error: error)
            case .success(let val):
                do {
                    let doc = try HTML(html: val, encoding: .utf8)
                    let baslik = doc.xpath("//*[@id='entry-item-list']/li").first
                    if let entry = baslik?.xpath("div[@class='content']").first?.toHTML?.data(using: .utf8),
                        let author = baslik?.xpath("footer/div[@class='info']/a[@class='entry-author']").first?.text,
                        let date = baslik?.xpath("footer/div[@class='info']/a[@class='entry-date permalink']").first?.text,
                        let favoriteCount = baslik?.xpath("@data-favorite-count").first?.text,
                        let entryId = baslik?.xpath("@data-id").first?.text,
                        let authorId = baslik?.xpath("@data-author-id").first?.text,
                        let isFavorited = baslik?.xpath("@data-isfavorite").first?.text  {
                        
                        let attributedString = try NSMutableAttributedString(data: entry,
                                                                             options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                       .characterEncoding: String.Encoding.utf8.rawValue],
                                                                             documentAttributes: nil)
                        attributedString.setBaseFont(baseFont: UIFont.preferredFont(forTextStyle: .body))
                        
                        if #available(iOS 13.0, *) {
                            attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: attributedString.length))
                        }
                        // TODO FAV
                        let entry = Entry(content: attributedString.trimWhiteSpace(), author: author, date: date, favoritesCount: favoriteCount, entryId: entryId, authorId: authorId, isFavorited: isFavorited == "true" ? true : false)
                        self.entry = entry
                    }
                    
                } catch {
                    self.delegate?.failedGetSingleEntry(error: error)
                }
                
                self.delegate?.didGetSingleEntry()
            }
        }
    }
}

