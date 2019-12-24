//
//  HomeVM.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import Foundation
import Kanna
import GoogleMobileAds

protocol HomeVMProtocol: BaseVMProtocol {
    func getHomepage(number: Int)
    
    func initAdLoader(with: UIViewController)
}

protocol HomeVMOutputProtocol: BaseVMOutputProtocol {
    func didGetHomepage()
    func failedGetHomepage(error: Error)
}

final class HomeVM: NSObject, HomeVMProtocol {
    weak var delegate: HomeVMOutputProtocol?
    weak var coordinator: HomeCoordinator?
    
    let networkManager: NetworkManager
    
    var adLoader: GADAdLoader?
    private var nativeAds = [GADUnifiedNativeAd]()
    private(set) var headings = [Heading]()
    var tableViewItems = [AnyObject]()
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getHomepage(number: Int) {
        networkManager.getHomePage(number: number) { result in
            switch result {
            case .failure(let err):
                self.delegate?.failedGetHomepage(error: err)
            case .success(let val):
                do {
                    self.headings.removeAll()
                    self.nativeAds.removeAll()
                    self.tableViewItems.removeAll()
                    
                    let doc = try HTML(html: val, encoding: .utf8)
                    for headingData in doc.xpath("//*[@id='content-body']/ul/li/a") {
                        let heading = Heading(name: headingData.xpath("text()[1]").first?.text?.trimmingCharacters(in: .whitespaces),
                                              count: headingData.xpath("small/text()[1]").first?.text?.trimmingCharacters(in: .whitespaces),
                                              link: headingData["href"])
                        self.headings.append(heading)
                    }
                    self.tableViewItems = self.headings
                    if UserDefaults.standard.bool(forKey: "isAdsAllowed") {
                        self.adLoader?.load(GADRequest())
                    } else {
                        self.delegate?.didGetHomepage()
                    }
                } catch {
                    self.delegate?.failedGetHomepage(error: error)
                }
            }
        }
    }
    
    
    func openHeading(url: String) {
        coordinator?.openHeading(url: url)
    }
    
    func openLogin() {
        coordinator?.openLogin()
    }
    
    func initAdLoader(with: UIViewController) {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 3
        
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511",//"ca-app-pub-1229547290062551/1447347849",
                                rootViewController: with,
                                adTypes: [GADAdLoaderAdType.unifiedNative],
                                options: [multipleAdsOptions])
        adLoader?.delegate = self
    }
}

extension HomeVM: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        
        nativeAds.append(nativeAd)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        self.delegate?.didGetHomepage()
        print("ADERROR", error)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        for (index, ad) in nativeAds.enumerated() {
            tableViewItems.insert(ad, at: (index + 1) * 5)
        }
        self.delegate?.didGetHomepage()
    }
}
