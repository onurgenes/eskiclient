//
//  MessageDetailVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import Foundation
import Kanna

protocol MessageDetailVMProtocol: BaseVMProtocol {
    func getMessageDetails()
}

protocol MessageDetailVMOutputProtocol: BaseVMOutputProtocol {
    func didGetMessageDetails(result: Result<String, Error>)
}

final class MessageDetailVM: MessageDetailVMProtocol {
    weak var coordinator: MessageDetailCoordinator?
    weak var delegate: MessageDetailVMOutputProtocol?
    let networkManager: Networkable
    let url: String
    
    init(networkManager: Networkable, url: String) {
        self.networkManager = networkManager
        self.url = url
    }
    
    var messages = [MessageDetail]()
    
    func getMessageDetails() {
        guard let threadId = url.split(separator: "/").last,
            let id = Int(String(threadId)) else { return }
        networkManager.getMessageDetails(threadId: id) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didGetMessageDetails(result: .failure(error))
            case .success(let response):
                do {
                    let doc = try HTML(html: response, encoding: .utf8)
                    if let senderUsername = doc.xpath("//*[@id='message-thread-title']/a[2]").first?.text {
                        for messageDetail in doc.xpath("//*[@id='message-thread']/article") {
                            if var content = messageDetail.xpath("p").first?.text,
                                let date = messageDetail.xpath("footer/time").first?.text {
                                
                                var isIncoming = false
                                if let className = messageDetail.className, className == "incoming" {
                                    isIncoming = true
                                } else {
                                    if let index = content.range(of: ": ")?.upperBound {
                                        content = String(content.suffix(from: index))
                                    }
                                }
                                let message = MessageDetail(isIncoming: isIncoming, content: content, senderUsername: senderUsername, date: date)
                                self.messages.append(message)
                            }
                        }
                    }
                    self.delegate?.didGetMessageDetails(result: .success(""))
                } catch let error {
                    self.delegate?.didGetMessageDetails(result: .failure(error))
                }
            }
        }
    }
}
