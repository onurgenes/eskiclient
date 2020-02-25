//
//  MessageVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import Foundation
import Kanna
import FirebaseAnalytics

protocol MessageVMProtocol: BaseVMProtocol {
    func getMessages(page: Int)
    
    func openMessageDetail(url: String)
}

protocol MessageVMOutputProtocol: BaseVMOutputProtocol {
    func didGetMessages(result: Result<[Message], Error>)
}

final class MessageVM: MessageVMProtocol {
    weak var coordinator: MessageCoordinator?
    weak var delegate: MessageVMOutputProtocol?
    let networkManager: Networkable
    
    init(networkManager: Networkable) {
        self.networkManager = networkManager
    }
    
    var messages = [Message]()
    var currentPage = ""
    var pageCount = ""
    
    func getMessages(page: Int) {
        // ANALYTICS
        Analytics.logEvent("messagesRequested", parameters: ["isMessagesRequested": true])
        networkManager.getMessages(page: page) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didGetMessages(result: .failure(error))
            case .success(let response):
                do {
                    
                    self.messages.removeAll()
                    let doc = try HTML(html: response, encoding: .utf8)
                    if let currentPage = doc.xpath("//*[@id='message-thread-list-form']/div[@class='pager']/@data-currentpage").first?.text {
                        self.currentPage = currentPage
                    }
                    if let pageCount = doc.xpath("//*[@id='message-thread-list-form']/div[@class='pager']/@data-pagecount").first?.text {
                        self.pageCount = pageCount
                    }
                    for messageContent in doc.xpath("//*[@id='threads']/li/article") {
                        if let content = messageContent.xpath("a/p").first?.text,
                            let senderUsername = messageContent.xpath("a/h2").first?.text,
                            let date = messageContent.xpath("footer/time/@title").first?.text,
                            let threadId = doc.css("input[name^=threadId]").first?["value"],
                            let url = messageContent.xpath("a/@href").first?.text {
                            
                            let message = Message(threadId: threadId, senderUsername: senderUsername, content: content, date: date, url: url)
                            self.messages.append(message)
                        }
                    }
                    self.delegate?.didGetMessages(result: .success(self.messages))
                    
                    if let latestMessageDateString = self.messages.first?.date {
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                        
                        let savingDate = dateFormatter.date(from: latestMessageDateString)
                        UserDefaults.standard.set(savingDate, forKey: "lastMessageDate")
                    }
                    
                } catch let error {
                    self.delegate?.didGetMessages(result: .failure(error))
                }
            }
        }
    }
    
    func openMessageDetail(url: String) {
        coordinator?.openMessageDetail(url: url)
    }
}
