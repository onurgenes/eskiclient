//
//  AddEntryVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 21.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class AddEntryVC: BaseVC<AddEntryVM, AddEntryView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = app.window.screen.bounds
        preferredContentSize = CGSize(width: screenSize.width - 120, height: screenSize.height / 2)
        
        
    }
}

extension AddEntryVC: AddEntryVMOutputProtocol {
    
}
