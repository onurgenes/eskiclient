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
                    print(doc.title)
                    for baslik in doc.xpath("//div[@id='index-section']//li/a") {
                        print(baslik.text!)
                        print(baslik["href"]!)
                    }
                }
            }
        }
        
        AF.request("https://eksisozluk.com/basliklar/bugun/1").responseString { (response) in
            switch response.result {
            case .failure(let err):
                print("FAIL: \(err)")
            case .success(let val):
                if let doc = try? HTML(html: val, encoding: .utf8) {
                    print(doc.title!)
                    for baslik in doc.xpath("//div[@id='index-section']//li/a") {
                        print(baslik.text!)
                        print(baslik["href"]!)
                    }
                    AF.request("https://eksisozluk.com\(doc.xpath("//div[@id='index-section']//li/a").first!["href"]!)").responseString(completionHandler: { (res) in
                        //ul[@id='entry-item-list']/li
                        switch res.result {
                        case .failure(let err):
                            print("FAIL: \(err)")
                        case .success(let aa):
                            if let aaa = try? HTML(html: aa, encoding: .utf8) {
//                                for something in aaa.xpath("//ul[@id='entry-item-list']/li/div") {
//                                    print(something.text!.trimmingCharacters(in: .whitespacesAndNewlines))
//                                }
                                print(aaa.xpath("//ul[@id='entry-item-list']/li/div").first!.toHTML!)
                            }
                        }
                    })
                }
            }
        }
    }
}

