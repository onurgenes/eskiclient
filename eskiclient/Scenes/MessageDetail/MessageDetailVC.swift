//
//  MessageDetailVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import UIKit

final class MessageDetailVC: BaseTableVC<MessageDetailVM, MessageDetailCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getMessageDetails()
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
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
        }
    }
}
