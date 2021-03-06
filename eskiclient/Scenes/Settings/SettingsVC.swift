//
//  SettingsVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 24.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAnalytics
import MessageUI

final class SettingsVC: FormViewController {
    
    private var isProductsLoaded = false
    
    var viewModel: SettingsVM! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iapObserver.delegate = self
        
        form +++ Section(header: "reklam", footer: "uygulamaya destek olmak için reklamları açabilirsiniz :)") {
            $0.tag = "adsSection"
            }
            <<< SwitchRow("isAdsAllowed") {
                $0.title = "reklamları göster"
                $0.value = UserDefaults.standard.bool(forKey: "isAdsAllowed")
            }.onChange{ row in
                UserDefaults.standard.set(row.value, forKey: "isAdsAllowed")
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
            +++ Section(header: "destek", footer: "buradaki seçeneklerle istek ve önerilerini bize bildirebilirsin")
            <<< ButtonRow() {
                $0.title = "başlığa yaz"
                $0.onCellSelection(headingButtonTapped)
            }
            <<< ButtonRow() {
                $0.title = "maıl gönder"
                $0.onCellSelection(mailButtonTapped)
            }
        
        // If products loaded and init, load here else, wait for delegate method
        addProductsToForm()
    }
    
    func headingButtonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        viewModel.openEskiHeading()
    }
    
    func mailButtonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["onur@onurgenes.com"])
            if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                mail.setSubject("eşkiclient \(text)")
            }
            mail.setMessageBody("eşki hakkında:\n", isHTML: false)

            present(mail, animated: true)
        } else {
            let ac = UIAlertController(title: "pardon", message: "cihazın mail göndermeye uygun değilmiş", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "tamam", style: .cancel))
            self.present(ac, animated: true)
        }
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        if let product = (iapObserver.products.filter{ $0.productIdentifier == row.tag }).first {
            iapObserver.buy(product)
        }
    }
    
    func addProductsToForm() {
        if !isProductsLoaded {
            if let section = form.sectionBy(tag: "adsSection"), !iapObserver.products.isEmpty {
                
                isProductsLoaded = true
                
                for product in iapObserver.products {
                    section
                        <<< ButtonRow() {
                            $0.tag = product.productIdentifier
                            $0.hidden = Condition.function(["isAdsAllowed"], { form in
                                let formValue = ((form.rowBy(tag: "isAdsAllowed") as? SwitchRow)?.value ?? false)
                                // ANALYTICS
                                Analytics.logEvent("isAdsAllowed", parameters: ["allowed": formValue])
                                return formValue
                            })
                            var productTitle = ""
                            if product.productIdentifier == "com.onurgenes.eskiclient.kucukbagis" {
                                productTitle = "küçük destek - "
                            } else if product.productIdentifier == "com.onurgenes.eskiclient.buyukbagis" {
                                productTitle = "büyük destek - "
                            } else if product.productIdentifier == "com.onurgenes.eskiclient.devasabagis" {
                                productTitle = "devasa destek - "
                            }
                            $0.title = productTitle + product.regularPrice!
                            $0.onCellSelection(self.buttonTapped)
                    }
                }
            }
        }
        
    }
}

extension SettingsVC: SettingsVMOutputProtocol {
    
}

extension SettingsVC: StoreObserverOutputDelegate {
    func didPurchase() {
        let ac = UIAlertController(title: "teşekkürler!", message: "desteğin için teşekkürler! iyi ki varsın!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ne demek", style: .default))
        self.present(ac, animated: true)
    }
    
    func failedPurchase(error: Error) {
        let ac = UIAlertController(title: "eyvah!", message: "bir hata oldu...", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "tamam", style: .default))
        self.present(ac, animated: true)
    }
    
    func didGetProducts() {
        DispatchQueue.main.async {
            self.addProductsToForm()
        }
    }
}

extension SettingsVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
