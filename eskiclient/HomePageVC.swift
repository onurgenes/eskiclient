//
//  HomePageVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import Kanna
import Alamofire

class HomePageVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nm = NetworkManager()
        nm.getHomePage { result in
            switch result {
            case .failure(let err):
                print("FAIL: \(err)")
            case .success(let val):
                if let doc = try? HTML(html: val, encoding: .utf8) {
                    for baslik in doc.xpath("//li/a") {
                        print(baslik.text)
                        
                        // just "başlık name"
                        print(baslik.xpath("text()[1]").first?.text?.trimmingCharacters(in: .whitespaces))
                        
                        // just "başlık new entry count"
                        print(baslik.xpath("small/text()[1]").first?.text?.trimmingCharacters(in: .whitespaces))
                        print(baslik["href"])
                    }
                }
            }
        }
        // FOR GETTING "entries" of "başlık"
        
//                    AF.request("https://eksisozluk.com\(doc.xpath("//li/a").first!["href"]!)").responseString(completionHandler: { (res) in
//                        //ul[@id='entry-item-list']/li
//                        switch res.result {
//                        case .failure(let err):
//                            print("FAIL: \(err)")
//                        case .success(let aa):
//                            if let aaa = try? HTML(html: aa, encoding: .utf8) {
//                                //                                for something in aaa.xpath("//ul[@id='entry-item-list']/li/div") {
//                                //                                    print(something.text!.trimmingCharacters(in: .whitespacesAndNewlines))
//                                //                                }
//                                let html = aaa.xpath("//ul[@id='entry-item-list']/li/div").first!.toHTML!
//                                let data = Data(html.utf8)
//                                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
//                                    print(attributedString)
//                                }
//                            }
//                        }
//                    })
    }
}

