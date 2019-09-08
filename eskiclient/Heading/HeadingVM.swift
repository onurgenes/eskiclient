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
    func getHeading()
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
    
    init(networkManager: NetworkManager, url: String) {
        self.networkManager = networkManager
        self.url = url
    }
    
    func getHeading() {
        networkManager.getHeading(url: url) { result in
            switch result {
            case .failure(let err):
                print(err)
            case .success(let val):
                do {
                    let doc = try HTML(html: val, encoding: .utf8)
                    for baslik in doc.xpath("//*[@id='entry-item-list']/li") {
                        if let entry = baslik.xpath("div[@class='content']").first?.toHTML?.data(using: .utf8),
                            let author = baslik.xpath("footer/div[@class='info']/a[@class='entry-author']").first?.text,
                            let date = baslik.xpath("footer/div[@class='info']/a[@class='entry-date permalink']").first?.text {
                            let attributedString = try NSMutableAttributedString(data: entry, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                                       .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
                            attributedString.setBaseFont(baseFont: UIFont.preferredFont(forTextStyle: .body))
                            
                            self.authors.append(author)
                            self.entries.append(attributedString)
                            self.dates.append(date)
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
