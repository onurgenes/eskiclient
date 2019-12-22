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
        preferredContentSize = CGSize(width: screenSize.width - 60, height: screenSize.height / 2)
        
        baseView.sendButton.addTarget(self, action: #selector(sendEntry), for: .touchUpInside)
    }
    
    @objc func sendEntry() {
        if let text = baseView.entryTextView.text, !text.isEmpty {
            viewModel.sendEntry(text: text)
        }
    }
}

extension AddEntryVC: AddEntryVMOutputProtocol {
    func didSendEntry() {
        self.dismiss(animated: true)
    }
    
    func failedSendEntry(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
}
