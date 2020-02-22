//
//  MessageVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import Foundation
import Kanna

protocol MessageVMProtocol: BaseVMProtocol {
    func getMessages()
    
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
    
    func getMessages() {
        networkManager.getMessages(page: 1) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didGetMessages(result: .failure(error))
            case .success(let response):
                do {
                    let doc = try HTML(html: response, encoding: .utf8)
                    for messageContent in doc.xpath("//*[@id='threads']/li/article") {
                        if let content = messageContent.xpath("a/p").first?.text,
                            let senderUsername = messageContent.xpath("a/h2").first?.text,
                            let date = messageContent.xpath("footer/time").first?.text,
                            let threadId = doc.css("input[name^=threadId]").first?["value"],
                            let url = messageContent.xpath("a/@href").first?.text {
                            
                            let message = Message(threadId: threadId, senderUsername: senderUsername, content: content, date: date, url: url)
                            self.messages.append(message)
                        }
                    }
                    
                    self.delegate?.didGetMessages(result: .success(self.messages))
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
