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
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageDetailCell else { fatalError("Can not find MessageDetailCell") }
        
        return cell
    }
}

extension MessageDetailVC: MessageDetailVMOutputProtocol {
    func didGetMessageDetails(result: Result<String, Error>) {
        switch result {
        case .failure(let error):
            print(error)
        case .success(_):
            print("")
        }
    }
}
