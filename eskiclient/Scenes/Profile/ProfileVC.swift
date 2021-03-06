//
//  ProfileVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 18.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class ProfileVC: BaseTableVC<ProfileVM, ProfileCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .automatic
        
        if let username = viewModel.otherProfileUsername {
            title = username
            viewModel.getProfile(username: username)
        } else if let username = UserDefaults.standard.string(forKey: "currentUsername") {
            title = username
            viewModel.getProfile(username: username)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "çıkış yap", style: .plain, target: self, action: #selector(logoutTapped))
        }
    }
    
    @objc func logoutTapped() {
        viewModel.logout()
    }
}

extension ProfileVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userHeadings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ProfileCell else { fatalError() }
        let heading = viewModel.userHeadings[indexPath.row]
        cell.titleLabel.text = heading.text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let link = viewModel.userHeadings[indexPath.row].link {
            viewModel.openHeading(url: link)
        }
    }
}

extension ProfileVC: ProfileVMOutputProtocol {
    func didGetProfile() {
        tableView.reloadData()
    }
    
    func failedGetProfile(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
    
    func didLogout() {
        
    }
    
    func failedLogout(error: Error) {
        print(error)
    }
}
