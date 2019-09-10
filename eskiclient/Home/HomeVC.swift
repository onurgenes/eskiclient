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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getHomepage()
        
        title = "e$ki"
    }
}

extension HomeVC: HomeVMOutputProtocol {
    func didGetHomepage() {
        tableView.reloadData()
    }
    
    func failedGetHomepage(error: Error) {
        print(error)
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
