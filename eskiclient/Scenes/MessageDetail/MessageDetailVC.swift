//
//  MessageDetailVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import UIKit

final class MessageDetailVC: BaseTableVC<MessageDetailVM, MessageDetailCell> {
    
    private let footerView = MessageDetailFooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getMessageDetails()
        
        footerView.frame.size.height = 200
        tableView.tableFooterView = footerView
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
        
        footerView.sendButton.addTarget(self, action: #selector(sendNewMessage), for: .touchUpInside)
    }
    
    @objc func sendNewMessage() {
        guard let messageText = footerView.messageTextView.text else { return }
        viewModel.newMessageModel.message = messageText
        viewModel.sendMessage()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageDetailCell else { fatalError("Can not find MessageDetailCell") }
        let messageDetail = viewModel.messages[indexPath.row]
        cell.contentLabel.text = messageDetail.content
        cell.dateLabel.text = messageDetail.date
        cell.isIncoming = messageDetail.isIncoming!
        return cell
    }
}

extension MessageDetailVC: MessageDetailVMOutputProtocol {
    func didGetMessageDetails(result: Result<String, Error>) {
        switch result {
        case .failure(let error):
            print(error)
        case .success(_):
            tableView.reloadData()
            navigationItem.title = viewModel.messages.first?.senderUsername
            let indexPath = IndexPath(row: viewModel.messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: false)
        }
    }
}
