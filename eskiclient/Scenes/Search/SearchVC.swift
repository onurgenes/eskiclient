//
//  SearchVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class SearchVC: BaseTableVC<SearchVM, SearchCell> {
    
    lazy var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "entry ya da suser ara..."
        searchBar.isTranslucent = false
        searchBar.returnKeyType = .done
        searchBar.showsCancelButton = true
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        navigationItem.titleView = searchBar
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        searchBar.resignFirstResponder()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        tableView.reloadData()
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        viewModel.search(query: textSearched)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchVC: SearchVMOutputProtocol {
    
    func didSearch() {
        tableView.reloadData()
    }
    
    func failedSearch(error: Error) {
        print(error)
    }
}

extension SearchVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let count = viewModel.searchResult?.titles?.count {
                return count
            }
            return 0
        } else {
            if let count = viewModel.searchResult?.nicks?.count {
                return count
            }
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SearchCell else { fatalError() }
        if indexPath.section == 0 {
            let model = viewModel.searchResult?.titles?[indexPath.row]
            cell.titleLabel.text = model
            cell.typeImageView.image =  UIImage.fontAwesomeIcon(name: .fileAlt,
                                                                style: .solid,
                                                                textColor: traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray,
                                                                size: CGSize(width: 30, height: 30))
        } else {
            let model = viewModel.searchResult?.nicks?[indexPath.row]
            cell.titleLabel.text = model
            cell.typeImageView.image = UIImage.fontAwesomeIcon(name: .user,
                                                               style: .solid,
                                                               textColor: traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray,
                                                               size: CGSize(width: 30, height: 30))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
