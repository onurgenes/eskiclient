//
//  MessageVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import UIKit

final class MessageVC: BaseTableVC<MessageVM, MessageCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getMessages()
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MessageCell else { fatalError("Can not find MessageCell") }
        let message = viewModel.messages[indexPath.row]
        cell.usernameLabel.text = message.senderUsername
        cell.contentLabel.text = message.content
        cell.dateLabel.text = message.date
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = viewModel.messages[indexPath.row].url else { return }
        viewModel.openMessageDetail(url: url)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }

}

extension MessageVC: MessageVMOutputProtocol {
    func didGetMessages(result: Result<[Message], Error>) {
        switch result {
        case .failure(let error):
            print(error)
        case .success(_):
            tableView.reloadData()
        }
    }
}
