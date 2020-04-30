//
//  HomeVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import GoogleMobileAds
import TinyConstraints

final class HomeVC: BaseTableVC<HomeVM, HomeCell> {
    
    private var bannerHeightConstraint: Constraint?
    
    lazy var tableRefreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(getHomePage), for: .valueChanged)
        return rc
    }()
    
    lazy var bannerView: GADBannerView = {
        let bv = GADBannerView(adSize: kGADAdSizeBanner)
        bv.adUnitID = "ca-app-pub-1229547290062551/5824387185"
        bv.rootViewController = self
        bv.delegate = self
        return bv
    }()
    
    private let footerView = HeadingFooterView()
    private var currentPageNumber = 1
    
    private let adCellId = "adCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.initAdLoader(with: self)
        
        getHomePage()
        setupBanner()
        
        tableView.refreshControl = tableRefreshControl
        tableView.tableFooterView = footerView
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.register(HomeAdCell.self, forCellReuseIdentifier: adCellId)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        
        footerView.frame.size.height = 80
        footerView.nextPageButton.addTarget(self, action: #selector(getNextPage), for: .touchUpInside)
        footerView.previousPageButton.addTarget(self, action: #selector(getPreviousPage), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "giriş", style: .plain, target: self, action: #selector(openLoginTapped))
        NotificationCenter.default.addObserver(self, selector: #selector(removeLoginButton(_:)), name: .loginNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getHomePage), name: .checkLoginNotificationName, object: nil)
        
        setupBanner()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
    }
    
    @objc func removeLoginButton(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Bool],
            let isLoggedIn = data["isLoggedIn"] {
            if isLoggedIn {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    @objc func getNextPage() {
        currentPageNumber += 1
        tableRefreshControl.beginRefreshing()
        viewModel.getHomepage(number: currentPageNumber)
    }
    
    @objc func getPreviousPage() {
        if currentPageNumber == 1 {
            return
        }
        currentPageNumber -= 1
        tableRefreshControl.beginRefreshing()
        viewModel.getHomepage(number: currentPageNumber)
    }
    
    @objc func getHomePage() {
        tableRefreshControl.beginRefreshing()
        viewModel.getHomepage(number: 1)
    }
    
    @objc func openLoginTapped() {
        viewModel.openLogin()
    }
    
    func setupBanner() {
        tableView.addSubview(bannerView)
        bannerView.edgesToSuperview(excluding: .top, usingSafeArea: true)
        bannerHeightConstraint = bannerView.height(bannerView.intrinsicContentSize.height)
        
        let request = GADRequest()
        bannerView.load(request)
    }
}

extension HomeVC: HomeVMOutputProtocol {
    func didGetHomepage() {
        tableRefreshControl.endRefreshing()
        footerView.currentPageNumberLabel.text = String(currentPageNumber)
        tableView.reloadData()
        guard viewModel.headings.count > 0 else {
            SwiftMessagesViewer.error(message: "başlıklar getirilemedi...")
            return
        }
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func failedGetHomepage(error: Error) {
        SwiftMessagesViewer.error(message: error.localizedDescription)
    }
}

extension HomeVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableViewItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.tableViewItems[indexPath.row]
        if let item = item as? GADUnifiedNativeAd  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: adCellId, for: indexPath) as? HomeAdCell else { fatalError() }
            
            item.delegate = self
            
            cell.nativeAdView.nativeAd = item
            
//            cell.heightConstraint?.isActive = false
//            if let mediaView = cell.nativeAdView.mediaView, item.mediaContent.aspectRatio > 0 {
//                cell.heightConstraint = NSLayoutConstraint(item: mediaView,
//                                                           attribute: .height,
//                                                           relatedBy: .equal,
//                                                           toItem: mediaView,
//                                                           attribute: .width,
//                                                           multiplier: CGFloat(1 / item.mediaContent.aspectRatio),
//                                                           constant: 0)
//                cell.heightConstraint?.isActive = true
//            }
//
//            cell.nativeAdView.layoutIfNeeded()

            (cell.nativeAdView.bodyView as? UILabel)?.text = item.body
            cell.nativeAdView.bodyView?.isHidden = item.body == nil
            
            (cell.nativeAdView.callToActionView as? UIButton)?.setTitle(item.callToAction, for: .normal)
            cell.nativeAdView.callToActionView?.isHidden = item.callToAction == nil
            
            (cell.nativeAdView.iconView as? UIImageView)?.image = item.icon?.image
            cell.nativeAdView.iconView?.isHidden = item.icon == nil
            
            cell.nativeAdView.starRatingView?.isHidden = item.starRating == nil
            
            (cell.nativeAdView.storeView as? UILabel)?.text = item.store
            cell.nativeAdView.storeView?.isHidden = item.store == nil
            
            (cell.nativeAdView.priceView as? UILabel)?.text = item.price
            cell.nativeAdView.priceView?.isHidden = item.price == nil
            
            (cell.nativeAdView.advertiserView as? UILabel)?.text = item.advertiser
            cell.nativeAdView.advertiserView?.isHidden = item.advertiser == nil
            
            cell.nativeAdView.mediaView?.mediaContent = item.mediaContent
            
            (cell.nativeAdView.headlineView as? UILabel)?.text = item.headline
            // In order for the SDK to process touch events properly, user interaction should be disabled.
            cell.nativeAdView.callToActionView?.isUserInteractionEnabled = false
            
            (cell.nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: item.starRating)
            cell.nativeAdView.starRatingView?.isHidden = item.starRating == nil
            return cell
        } else {
            let heading = item as? Heading
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HomeCell else { fatalError() }
            cell.titleLabel.text = heading?.name
            cell.countLabel.text = heading?.count
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = viewModel.tableViewItems[indexPath.row] as? Heading, let link = item.link {
            viewModel.openHeading(url: link)
        } else {
            SwiftMessagesViewer.error(message: "link açılmıyor")
        }
    }
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
}

extension HomeVC : GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        
    }
}

extension HomeVC: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("BANNER",#function)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bannerView.intrinsicContentSize.height, right: 0)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("BANNER",error.localizedDescription)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        shrinkBanner(animated: true)
    }
    
    func shrinkBanner(animated: Bool) {
        bannerHeightConstraint?.constant = 0
        self.view.setNeedsLayout()
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
        
    }
}
