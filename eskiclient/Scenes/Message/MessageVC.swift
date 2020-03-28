//
//  MessageVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import UIKit
import FirebaseAnalytics

final class MessageVC: BaseTableVC<MessageVM, MessageCell> {
    
    lazy var tableRefreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshMessages), for: .valueChanged)
        return rc
    }()
    
    private let footerView = HeadingFooterView()
    private var currentPageNumber = 1
    private var pageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getMessages(page: 1)
        
        tableView.refreshControl = tableRefreshControl
        tableView.tableFooterView = footerView
        footerView.frame.size.height = 80
        footerView.nextPageButton.addTarget(self, action: #selector(getNextPage), for: .touchUpInside)
        footerView.previousPageButton.addTarget(self, action: #selector(getPreviousPage), for: .touchUpInside)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            
            Analytics.logEvent("grantedNotificationPermission", parameters: ["isGranted": granted])
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getMessages(page: currentPageNumber)
    }
    
    @objc func refreshMessages() {
        viewModel.getMessages(page: 1)
    }
    
    @objc func getNextPage() {
        currentPageNumber += 1
        if currentPageNumber > pageCount {
            currentPageNumber = pageCount
            return
        }
        viewModel.getMessages(page: currentPageNumber)
    }
    
    @objc func getPreviousPage() {
        if currentPageNumber == 1 {
            return
        }
        currentPageNumber -= 1
        viewModel.getMessages(page: currentPageNumber)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MessageCell else { fatalError("Can not find MessageCell") }
        let message = viewModel.messages[indexPath.row]
        cell.usernameLabel.text = message.senderUsername
        cell.usernameLabel.textColor = message.isUnread ? R.color.themeMainDark() : nil
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
        tableRefreshControl.endRefreshing()
        switch result {
        case .failure(let error):
            print(error)
        case .success(let messages):
            tableView.reloadData()
            if messages.count > 0 {
                tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                footerView.currentPageNumberLabel.text = String(viewModel.currentPage)
                pageCount = Int(viewModel.pageCount) ?? 0
            }
        }
    }
}
