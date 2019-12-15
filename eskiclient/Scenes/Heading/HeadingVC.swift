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
    private var isWithoutDate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderFooter()
        viewModel.getHeading(isWithoutDate: false, focusTo: "", pageNumber: nil)
    }
    
    private func setHeaderFooter() {
        headerView.frame.size.height = 40
        footerView.frame.size.height = 40
        tableView.tableFooterView = footerView
        tableView.tableHeaderView = headerView
        
        headerView.showAllButton.addTarget(self, action: #selector(getEntriesWithoutDate), for: .touchUpInside)
        
        footerView.nextPageButton.addTarget(self, action: #selector(getNextPage), for: .touchUpInside)
        footerView.previousPageButton.addTarget(self, action: #selector(getPreviousPage), for: .touchUpInside)
    }
    
    @objc func getEntriesWithoutDate() {
        tableView.tableHeaderView = nil
        isWithoutDate = true
        viewModel.getHeading(isWithoutDate: true, focusTo: viewModel.focusToNumber, pageNumber: nil)
    }
    
    @objc func getNextPage() {
        if var currentPageNumber = Int(viewModel.currentPageNumber) {
            currentPageNumber += 1
            viewModel.getHeading(isWithoutDate: isWithoutDate, focusTo: "", pageNumber: String(currentPageNumber))
        }
    }
    
    @objc func getPreviousPage() {
        if var currentPageNumber = Int(viewModel.currentPageNumber) {
            currentPageNumber -= 1
            viewModel.getHeading(isWithoutDate: isWithoutDate, focusTo: "", pageNumber: String(currentPageNumber))
        }
    }
}

extension HeadingVC: HeadingVMOutputProtocol {
    func didGetHeading() {
        title = viewModel.title
        footerView.currentPageNumberLabel.text = viewModel.currentPageNumber
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func failedGetHeading(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
}

extension HeadingVC: TappedAuthorProtocol {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HeadingCell else { fatalError() }
        let entry = viewModel.entries[indexPath.row]
        cell.contentTextView.attributedText = entry.content
        cell.contentTextView.delegate = self
        cell.authorButton.setTitle(entry.author, for: .normal)
        cell.delegate = self
        cell.dateButton.setTitle(entry.date, for: .normal)
        cell.favoriteCountLabel.text = entry.favoritesCount + " favori"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.entries.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func didTappedAuthor(name: String) {
        viewModel.openSelectedAuthor(name: name)
    }
}

extension HeadingVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if !URL.absoluteString.starts(with: "http") {
            print(URL)
            let queryString = String(URL.absoluteString.removingPercentEncoding?.split(separator: "/").last ?? "")
            viewModel.openSelectedHeading(url: queryString)
            return false
        }
        return true
    }
}
