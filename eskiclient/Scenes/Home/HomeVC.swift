//
//  HomeVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import Kanna
import Alamofire

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
        footerView.frame.size.height = 40
        footerView.nextPageButton.addTarget(self, action: #selector(getNextPage), for: .touchUpInside)
        footerView.previousPageButton.addTarget(self, action: #selector(getPreviousPage), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "giriş", style: .plain, target: self, action: #selector(openLoginTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeLoginButton), name: .loginNotificationName, object: nil)
    }
    
    @objc func removeLoginButton() {
        navigationItem.rightBarButtonItem = nil
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
        return viewModel.headingNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HomeCell else { fatalError() }
        let currentCellNumber = indexPath.row
        cell.titleLabel.text = viewModel.headingNames[currentCellNumber]
        cell.countLabel.text = viewModel.headingCounts[currentCellNumber]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let link = viewModel.headingLinks[indexPath.row] {
            viewModel.openHeading(url: link)
        } else {
            print("Can't get link")
        }
    }
}
