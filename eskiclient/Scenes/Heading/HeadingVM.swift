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
    func openSelectedEntry(number: String)
    func openOutsideLink(url: URL)
    func openAddEntry()
}

protocol HeadingVMOutputProtocol: BaseVMOutputProtocol {
    func didGetHeading()
    func failedGetHeading(error: Error)
}

final class HeadingVM: HeadingVMProtocol {
    weak var delegate: HeadingVMOutputProtocol?
    weak var coordinator: HeadingCoordinator?
    let networkManager: NetworkManager
    var url: String
    var isQuery: Bool
    var isComingFromHeading: Bool
    
    private(set) var entries = [Entry]()
    private(set) var title = ""
    private(set) var currentPageNumber = ""
    private(set) var lastPageNumber = ""
    private(set) var focusToNumber = ""
    private(set) var newEntryModel = NewEntryModel()
    
    init(networkManager: NetworkManager, url: String, isQuery: Bool, isComingFromHeading: Bool) {
        self.networkManager = networkManager
        self.url = url
        self.isQuery = isQuery
        self.isComingFromHeading = isComingFromHeading
    }
    
    func getHeading(isWithoutDate: Bool, focusTo: String, pageNumber: String?) {
        networkManager.getHeading(url: url, isWithoutDate: isComingFromHeading ? true : isWithoutDate, focusTo: focusTo, pageNumber: pageNumber, isQuery: isQuery) { result in
            switch result {
            case .failure(let err):
                self.delegate?.failedGetHeading(error: err)
            case .success(let val):
                self.entries.removeAll()
                do {
                    let doc = try HTML(html: val, encoding: .utf8)
                    if let newUrl = doc.xpath("//h1[@id='title']/a[@itemprop='url']/@href").first?.content {
                        self.isQuery = false
                        self.url = String(newUrl.split(separator: "/").last!)
                    }
                    if let title = doc.title, let seperatedTitle = title.split(separator: "-").first {
                        self.title = String(seperatedTitle)
                    }
                    if let token = doc.css("input[name^=__RequestVerificationToken]").first?["value"] {
                        self.newEntryModel.token = token
                    }
                    if let id = doc.css("input[name^=Id]").first?["value"] {
                        self.newEntryModel.id = id
                    }
                    if let returnUrl = doc.css("input[name^=ReturnUrl]").first?["value"] {
                        self.newEntryModel.returnUrl = returnUrl
                    }
                    if let inputStartTime = doc.css("input[name^=InputStartTime]").first?["value"] {
                        self.newEntryModel.inputStartTime = inputStartTime
                    }
                    if let requestTitle = doc.css("input[name^=Title]").first?["value"] {
                        self.newEntryModel.title = requestTitle
                    }
                    if let currentPageNumber = doc.xpath("//*[@id='topic']/div[@class='clearfix sub-title-container']/div[@class='pager']/@data-currentpage").first?.text {
                        self.currentPageNumber = currentPageNumber
                    }
                    if let focusTo = doc.xpath("//*[@id='topic']/a[1]/@href").first?.text,
                        let focusToNumber = focusTo.split(separator: "=").last {
                        self.focusToNumber = String(focusToNumber)
                    }
                    if let lastPageNumber = doc.xpath("//*[@id='topic']/div[@class='clearfix sub-title-container']/div[@class='pager']/@data-pagecount").first?.text {
                        self.lastPageNumber = lastPageNumber
                    }
                    for baslik in doc.xpath("//*[@id='entry-item-list']/li") {
                        if let entry = baslik.xpath("div[@class='content']").first?.toHTML?.data(using: .utf8),
                            let author = baslik.xpath("footer/div[@class='info']/a[@class='entry-author']").first?.text,
                            let date = baslik.xpath("footer/div[@class='info']/a[@class='entry-date permalink']").first?.text,
                            let favoriteCount = baslik.xpath("@data-favorite-count").first?.text,
                            let entryId = baslik.xpath("@data-id").first?.text {
                            let attributedString = try NSMutableAttributedString(data: entry,
                                                                                 options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                           .characterEncoding: String.Encoding.utf8.rawValue],
                                                                                 documentAttributes: nil)
                            attributedString.setBaseFont(baseFont: UIFont.preferredFont(forTextStyle: .body))
                            
                            if #available(iOS 13.0, *) {
                                attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: attributedString.length))
                            }
                            let entry = Entry(content: attributedString.trimWhiteSpace(), author: author, date: date, favoritesCount: favoriteCount, entryId: entryId)
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
    
    func openSelectedEntry(number: String) {
        coordinator?.openEntry(number: number)
    }
    
    func openAddEntry() {
        coordinator?.openAddEntry(newEntryModel: newEntryModel)
    }
    
    func openOutsideLink(url: URL) {
        coordinator?.openOutsideLink(url: url)
    }
}
