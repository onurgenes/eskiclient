//
//  SingleEntryVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 24.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit

final class SingleEntryVC: BaseVC<SingleEntryVM, SingleEntryView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = app.window.screen.bounds
        preferredContentSize = CGSize(width: screenSize.width - 60, height: screenSize.height / 2)
        
        viewModel.getSingleEntry()
    }
    
}

extension SingleEntryVC: SingleEntryVMOutputProtocol {
    func didGetSingleEntry() {
        let entry = viewModel.entry
        baseView.authorButton.setTitle(entry?.author, for: .normal)
        baseView.dateButton.setTitle(entry?.date, for: .normal)
        baseView.favoriteCountLabel.text = (entry?.favoritesCount ?? "-") + " favori"
        baseView.contentTextView.attributedText = entry?.content
    }
    
    func failedGetSingleEntry(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
}
