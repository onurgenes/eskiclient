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
    func getHeading(isWithoutDate: Bool)
}

protocol HeadingVMOutputProtocol: BaseVMOutputProtocol {
    func didGetHeading()
    func failedGetHeading(error: Error)
}

final class HeadingVM: HeadingVMProtocol {
    weak var delegate: HeadingVMOutputProtocol?
    weak var coordinator: Coordinator?
    let networkManager: NetworkManager
    var url: String
    
    private(set) var entries = [NSAttributedString]()
    private(set) var authors = [String]()
    private(set) var dates = [String]()
    private(set) var favorites = [String]()
    private(set) var title = ""
    
    init(networkManager: NetworkManager, url: String) {
        self.networkManager = networkManager
        self.url = url
    }
    
    func getHeading(isWithoutDate: Bool) {
        networkManager.getHeading(url: url, isWithoutDate: isWithoutDate) { result in
            switch result {
            case .failure(let err):
                print(err)
            case .success(let val):
                self.entries.removeAll()
                self.dates.removeAll()
                self.authors.removeAll()
                do {
                    let doc = try HTML(html: val, encoding: .utf8)
                    if let title = doc.title, let seperatedTitle = title.split(separator: "-").first {
                        self.title = String(seperatedTitle)
                    }
                    for baslik in doc.xpath("//*[@id='entry-item-list']/li") {
                        if let entry = baslik.xpath("div[@class='content']").first?.toHTML?.data(using: .utf8),
                            let author = baslik.xpath("footer/div[@class='info']/a[@class='entry-author']").first?.text,
                            let date = baslik.xpath("footer/div[@class='info']/a[@class='entry-date permalink']").first?.text,
                            let favoriteCount = baslik.xpath("@data-favorite-count").first?.text {
                            let attributedString = try NSMutableAttributedString(data: entry, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                                       .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
                            attributedString.setBaseFont(baseFont: UIFont.preferredFont(forTextStyle: .body))
                            
                            self.authors.append(author)
                            self.entries.append(attributedString.trimWhiteSpace())
                            self.dates.append(date)
                            self.favorites.append(favoriteCount)
                        }
                    }
                    self.delegate?.didGetHeading()
                    
                } catch {
                    self.delegate?.failedGetHeading(error: error)
                }
            }
        }
    }
}
