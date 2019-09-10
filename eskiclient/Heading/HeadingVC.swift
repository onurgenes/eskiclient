//
//  HeadingVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class HeadingVC: BaseTableVC<HeadingVM, HeadingCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getHeading()
    }
}

extension HeadingVC: HeadingVMOutputProtocol {
    func didGetHeading() {
        tableView.reloadData()
    }
    
    func failedGetHeading(error: Error) {
        print(error)
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
