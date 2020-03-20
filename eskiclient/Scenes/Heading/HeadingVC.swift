//
//  HeadingVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import ContextMenu
//import TinyConstraints

final class HeadingVC: BaseTableVC<HeadingVM, HeadingCell> {
    
    private let headerView = HeadingHeaderView()
    private let footerView = HeadingFooterView()
    private var isWithoutDate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderFooter()
        viewModel.getHeading(isWithoutDate: false, focusTo: "", pageNumber: nil)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        tableView.separatorStyle = .none
        
        if UserDefaults.standard.string(forKey: "currentUsername") != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "entry gir", style: .plain, target: self, action: #selector(addEntry))
        }
    }
    
    @objc func addEntry() {
        viewModel.openAddEntry()
    }
    
    private func setHeaderFooter() {
        headerView.frame.size.height = 60
        footerView.frame.size.height = 80
        
        tableView.tableFooterView = footerView
        tableView.tableHeaderView = headerView
        
        headerView.showAllButton.addTarget(self, action: #selector(getEntriesWithoutDate), for: .touchUpInside)
        
        footerView.nextPageButton.addTarget(self, action: #selector(getNextPage), for: .touchUpInside)
        footerView.previousPageButton.addTarget(self, action: #selector(getPreviousPage), for: .touchUpInside)
        //addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getPreviousPage)))
        
        let backLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(getFirstPage(_:)))
        backLongPressGesture.minimumPressDuration = 1.0
        backLongPressGesture.delaysTouchesEnded = true
        footerView.previousPageButton.addGestureRecognizer(backLongPressGesture)
        
        let nextLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(getLastPage(_:)))
        nextLongPressGesture.minimumPressDuration = 1.0
        nextLongPressGesture.delaysTouchesEnded = true
        footerView.nextPageButton.addGestureRecognizer(nextLongPressGesture)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
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
    
    @objc func getFirstPage(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .ended:
            viewModel.getHeading(isWithoutDate: isWithoutDate, focusTo: "", pageNumber: "1")
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        default:
            break
        }
    }
    
    @objc func getLastPage(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .ended:
            viewModel.getHeading(isWithoutDate: isWithoutDate, focusTo: "", pageNumber: viewModel.lastPageNumber)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        default:
            break
        }
    }
}

extension HeadingVC: HeadingVMOutputProtocol {
    func didGetHeading() {
        title = viewModel.title
        footerView.currentPageNumberLabel.text = viewModel.currentPageNumber
        tableView.reloadData()
        if viewModel.entries.count >= 0 {
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func failedGetHeading(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
    
    func didVote(message: String) {
        SwiftMessagesViewer.success(title: message, backgroundColor: R.color.themeMain()!)
    }
    
    func failedVote(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
    
    func didFav(isSucces: Bool) {
        SwiftMessagesViewer.success(title: "favlandı", backgroundColor: R.color.themeMain()!)
    }
    
    func failedFav(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
    
    func didRemoveFav(isSuccess: Bool) {
        SwiftMessagesViewer.success(title: "fav kalktı", backgroundColor: R.color.themeMain()!)
    }
    
    func failedRemoveFav(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
}

extension HeadingVC: HeadingTappedDelegate {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HeadingCell else { fatalError() }
        if let entry = viewModel.entries[safe: indexPath.row] {
            cell.setupWith(entry: entry)
            cell.delegate = self
            cell.contentTextView.delegate = self
        } else {
            SwiftMessagesViewer.error(message: "Eğer bu hatayı görüyorsanız lütfen bize bildirin!")
        }
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
    
    func didTappedOnOptions(entry: Entry, cell: UITableViewCell) {
        print(entry.entryId)
        let ac = UIAlertController(title: "seçenekler", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "resim olarak paylaş", style: .default, handler: { _ in
            let image = UIImage(view: cell)
            let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(ac, animated: true)
        }))
        ac.addAction(UIAlertAction(title: "link olarak paylaş", style: .default, handler: { _ in
            guard let url = URL(string: "https://eksisozluk.com/entry/" + entry.entryId) else { return }
            let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(ac, animated: true)
        }))
        if entry.isFavorited {
            ac.addAction(UIAlertAction(title: "favlama", style: .default, handler: { _ in
                self.viewModel.removeFav(entryId: entry.entryId)
            }))
        } else {
            ac.addAction(UIAlertAction(title: "favla", style: .default, handler: { _ in
                self.viewModel.fav(entryId: entry.entryId)
            }))
        }
        
        ac.addAction(UIAlertAction(title: "yukarı oyla", style: .default, handler: { _ in
            self.viewModel.vote(entry: entry, isUpVote: true)
        }))
        ac.addAction(UIAlertAction(title: "aşağı oyla", style: .default, handler: { _ in
            self.viewModel.vote(entry: entry, isUpVote: false)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(ac, animated: true)
    }
}

extension HeadingVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if !URL.absoluteString.starts(with: "http") {
            let params = URL.absoluteString.removingPercentEncoding?.split(separator: "/")
            if params?.contains("entry") ?? false {
                viewModel.openSelectedEntry(number: String(params?.last ?? ""))
                return false
            }
            let queryString = String(URL.absoluteString.removingPercentEncoding?.split(separator: "/").last ?? "")
            viewModel.openSelectedHeading(url: queryString)
            return false
        }
        viewModel.openOutsideLink(url: URL)
        return false
    }
}
