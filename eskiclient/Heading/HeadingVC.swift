//
//  HeadingVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class HeadingVC: BaseTableVC<HeadingVM, HeadingCell> {
    
    private let headerView = HeadingHeaderView()
    private let footerView = HeadingFooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderFooter()
        viewModel.getHeading(isWithoutDate: false)
    }
    
    private func setHeaderFooter() {
        headerView.frame.size.height = 40
        footerView.frame.size.height = 40
        tableView.tableFooterView = footerView
        tableView.tableHeaderView = headerView
        
        headerView.showAllButton.addTarget(self, action: #selector(getEntriesWithoutDate), for: .touchUpInside)
    }
    
    @objc func getEntriesWithoutDate() {
        tableView.tableHeaderView = nil
        viewModel.getHeading(isWithoutDate: true)
    }
}

extension HeadingVC: HeadingVMOutputProtocol {
    func didGetHeading() {
        title = viewModel.title
        tableView.reloadData()
    }
    
    func failedGetHeading(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
}

extension HeadingVC {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HeadingCell else { fatalError() }
        let currentCellNumber = indexPath.row
        cell.contentTextView.attributedText = viewModel.entries[currentCellNumber]
        cell.authorButton.setTitle(viewModel.authors[currentCellNumber], for: .normal)
        cell.dateButton.setTitle(viewModel.dates[currentCellNumber], for: .normal)
        cell.favoriteCountLabel.text = viewModel.favorites[currentCellNumber] + " favori"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.entries.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
