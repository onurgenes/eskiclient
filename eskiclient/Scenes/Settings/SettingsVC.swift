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
            
            +++ Section(header: "ikon", footer: "ana ekranda görmek istediğiniz ikonu seçin")
            <<< SegmentedRow<String>() { row in
                row.options = ["yazı", "ekşi"]
                switch UIApplication.shared.alternateIconName {
                case "Icon-alt":
                    row.value = "ekşi"
                default:
                    row.value = "yazı"
                }
            }.onChange{ row in
                switch row.value {
                case "yazı":
                    UIApplication.shared.setAlternateIconName(nil)
                case "ekşi":
                    UIApplication.shared.setAlternateIconName("Icon-alt")
                default:
                    break
                }
            }
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        print("tapped!")
    }
}

extension SettingsVC: SettingsVMOutputProtocol {
    
}
