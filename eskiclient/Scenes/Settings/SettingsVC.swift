//
//  SettingsVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 24.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import Eureka

final class SettingsVC: FormViewController {
    
    var viewModel: SettingsVM! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section(header: "reklam", footer: "uygulamaya destek olmak için reklamları açabilirsiniz :)")
            <<< SwitchRow("isAdsAllowed") {
                $0.title = "reklamları göster"
                $0.value = UserDefaults.standard.bool(forKey: "isAdsAllowed")
            }.onChange{ row in
                UserDefaults.standard.set(row.value, forKey: "isAdsAllowed")
            }
            <<< ButtonRow(){
                
                $0.hidden = Condition.function(["isAdsAllowed"], { form in
                    return ((form.rowBy(tag: "isAdsAllowed") as? SwitchRow)?.value ?? false)
                })
                $0.title = "bağış yap"
                $0.onCellSelection(self.buttonTapped)
        }
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        print("tapped!")
    }
}

extension SettingsVC: SettingsVMOutputProtocol {
    
}
