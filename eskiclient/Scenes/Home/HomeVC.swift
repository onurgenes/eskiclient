//
//  HomeVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class HomeVC: BaseTableVC<HomeVM, HomeCell> {
    
    lazy var tableRefreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(getHomePage), for: .valueChanged)
        return rc
    }()
    
    private let footerView = HeadingFooterView()
    private var currentPageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHomePage()
        
        tableView.refreshControl = tableRefreshControl
        tableView.tableFooterView = footerView
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        footerView.frame.size.height = 80
        footerView.nextPageButton.addTarget(self, action: #selector(getNextPage), for: .touchUpInside)
        footerView.previousPageButton.addTarget(self, action: #selector(getPreviousPage), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "giriş", style: .plain, target: self, action: #selector(openLoginTapped))
        NotificationCenter.default.addObserver(self, selector: #selector(removeLoginButton(_:)), name: .loginNotificationName, object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }
    
    @objc func removeLoginButton(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Bool],
            let isLoggedIn = data["isLoggedIn"] {
            if isLoggedIn {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    @objc func getNextPage() {
        currentPageNumber += 1
        tableRefreshControl.beginRefreshing()
        viewModel.getHomepage(number: currentPageNumber)
    }
    
    @objc func getPreviousPage() {
        currentPageNumber -= 1
        tableRefreshControl.beginRefreshing()
        viewModel.getHomepage(number: currentPageNumber)
    }
    
    @objc func getHomePage() {
        tableRefreshControl.beginRefreshing()
        viewModel.getHomepage(number: 1)
    }
    
    @objc func openLoginTapped() {
        viewModel.openLogin()
    }
}

extension HomeVC: HomeVMOutputProtocol {
    func didGetHomepage() {
        tableRefreshControl.endRefreshing()
        footerView.currentPageNumberLabel.text = String(currentPageNumber)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func failedGetHomepage(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
}

extension HomeVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.headings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HomeCell else { fatalError() }
        let heading = viewModel.headings[indexPath.row]
        cell.titleLabel.text = heading.name
        cell.countLabel.text = heading.count
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let link = viewModel.headings[indexPath.row].link {
            viewModel.openHeading(url: link)
        } else {
            print("Can't get link")
        }
    }
}
