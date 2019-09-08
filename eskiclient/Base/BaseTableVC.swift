//
//  BaseTableVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

class BaseTableVC<VM: BaseVMProtocol, CELL: UITableViewCell>: UITableViewController {
    internal let cellId = "cellId"
    var viewModel: VM! {
        didSet {
            viewModel.delegate = self as? VM.OutputProtocol
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CELL.self, forCellReuseIdentifier: cellId)
    }
}

extension BaseTableVC: BaseVMOutputProtocol { }
