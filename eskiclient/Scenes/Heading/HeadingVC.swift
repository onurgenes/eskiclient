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
    
    //    lazy var floatingButton: UIButton = {
    //        let btn = UIButton(type: .system)
    //        btn.layer.cornerRadius = 20
    //        btn.setTitle("+", for: .normal)
    //        btn.backgroundColor = .red
    //        btn.layer.masksToBounds = true
    //        return btn
    //    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderFooter()
        viewModel.getHeading(isWithoutDate: false, focusTo: "", pageNumber: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "entry gir", style: .plain, target: self, action: #selector(addEntry))
        
        //        view.addSubview(floatingButton)
        //        floatingButton.edgesToSuperview(excluding: [.left, .top], insets: TinyEdgeInsets(top: 0, left: 0, bottom: 20, right: 20), usingSafeArea: true)
        //        floatingButton.height(40)
        //        floatingButton.widthToHeight(of: floatingButton)
    }
    
    @objc func addEntry() {
        viewModel.openAddEntry()
    }
    
    private func setHeaderFooter() {
        headerView.frame.size.height = 60
        footerView.frame.size.height = 80
        
        tableView.tableFooterView = footerView
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        headerView.showAllButton.addTarget(self, action: #selector(getEntriesWithoutDate), for: .touchUpInside)
        
        footerView.nextPageButton.addTarget(self, action: #selector(getNextPage), for: .touchUpInside)
        footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getPreviousPage)))
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(getFirstPage(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delaysTouchesEnded = true
        footerView.addGestureRecognizer(longPressGesture)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
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
            let queryString = String(URL.absoluteString.removingPercentEncoding?.split(separator: "/").last ?? "")
            viewModel.openSelectedHeading(url: queryString)
            return false
        }
        return true
    }
}

extension HeadingVC: ContextMenuDelegate {
    func contextMenuWillDismiss(viewController: UIViewController, animated: Bool) {
        
    }
    
    func contextMenuDidDismiss(viewController: UIViewController, animated: Bool) {
        print("hey")
    }
}
