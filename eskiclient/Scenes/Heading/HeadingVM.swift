//
//  HeadingVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation
import Kanna

protocol HeadingVMProtocol: BaseVMProtocol {
    func getHeading(isWithoutDate: Bool, focusTo: String, pageNumber: String?)
    func openSelectedAuthor(name: String)
    func openSelectedHeading(url: String)
}

protocol HeadingVMOutputProtocol: BaseVMOutputProtocol {
    func didGetHeading()
    func failedGetHeading(error: Error)
}

final class HeadingVM: HeadingVMProtocol {
    weak var delegate: HeadingVMOutputProtocol?
    weak var coordinator: HeadingCoordinator?
    let networkManager: NetworkManager
    let url: String
    let isQuery: Bool
    
    private(set) var entries = [Entry]()
    private(set) var title = ""
    private(set) var currentPageNumber = ""
    private(set) var focusToNumber = ""
    
    init(networkManager: NetworkManager, url: String, isQuery: Bool) {
        self.networkManager = networkManager
        self.url = url
        self.isQuery = isQuery
    }
    
    func getHeading(isWithoutDate: Bool, focusTo: String, pageNumber: String?) {
        networkManager.getHeading(url: url, isWithoutDate: isWithoutDate, focusTo: focusTo, pageNumber: pageNumber, isQuery: isQuery) { result in
            switch result {
            case .failure(let err):
                print(err)
            case .success(let val):
                self.entries.removeAll()
                do {
                    let doc = try HTML(html: val, encoding: .utf8)
                    if let title = doc.title, let seperatedTitle = title.split(separator: "-").first {
                        self.title = String(seperatedTitle)
                    }
                    if let currentPageNumber = doc.xpath("//*[@id='topic']/div[@class='clearfix sub-title-container']/div[@class='pager']/@data-currentpage").first?.text {
                        self.currentPageNumber = currentPageNumber
                    }
                    if let focusTo = doc.xpath("//*[@id='topic']/a[1]/@href").first?.text,
                        let focusToNumber = focusTo.split(separator: "=").last {
                        self.focusToNumber = String(focusToNumber)
                    }
                    for baslik in doc.xpath("//*[@id='entry-item-list']/li") {
                        if let entry = baslik.xpath("div[@class='content']").first?.toHTML?.data(using: .utf8),
                            let author = baslik.xpath("footer/div[@class='info']/a[@class='entry-author']").first?.text,
//                            let authorBiriURL = baslik.xpath("footer/div[@class='info']/a[@class='entry-author']/@href").first?.content,
//                            let authorLink = URL(string:  "https://eksisozluk.com/biri" + authorBiriURL),
                            let date = baslik.xpath("footer/div[@class='info']/a[@class='entry-date permalink']").first?.text,
                            let favoriteCount = baslik.xpath("@data-favorite-count").first?.text {
                            let attributedString = try NSMutableAttributedString(data: entry,
                                                                                 options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                           .characterEncoding: String.Encoding.utf8.rawValue],
                                                                                 documentAttributes: nil)
                            attributedString.setBaseFont(baseFont: UIFont.preferredFont(forTextStyle: .body))
                            
                            if #available(iOS 13.0, *) {
                                attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: attributedString.length))
                            }
                            let entry = Entry(content: attributedString.trimWhiteSpace(), author: author,/* authorLink: authorLink,*/ date: date, favoritesCount: favoriteCount)
                            self.entries.append(entry)
                        }
                    }
                    self.delegate?.didGetHeading()
                    
                } catch {
                    self.delegate?.failedGetHeading(error: error)
                }
            }
        }
    }
    
    func openSelectedHeading(url: String) {
        coordinator?.openSelectedHeading(url: url, isQuery: true)
    }
    
    func openSelectedAuthor(name: String) {
        let nameWithoutSpace = name.replacingOccurrences(of: " ", with: "-")
        coordinator?.openSelectedAuthor(name: nameWithoutSpace)
    }
}
