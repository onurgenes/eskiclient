//
//  HomeVC.swift
//  eskiclient
//
//  Created by Onur Geneş on 27.08.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import GoogleMobileAds

final class HomeVC: BaseTableVC<HomeVM, HomeCell> {
    
    lazy var tableRefreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(getHomePage), for: .valueChanged)
        return rc
    }()
    
    private let footerView = HeadingFooterView()
    private var currentPageNumber = 1
    
    private let adCellId = "adCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.initAdLoader(with: self)
        
        getHomePage()
        
        tableView.refreshControl = tableRefreshControl
        tableView.tableFooterView = footerView
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.register(HomeAdCell.self, forCellReuseIdentifier: adCellId)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        footerView.frame.size.height = 80
        footerView.nextPageButton.addTarget(self, action: #selector(getNextPage), for: .touchUpInside)
        footerView.previousPageButton.addTarget(self, action: #selector(getPreviousPage), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "giriş", style: .plain, target: self, action: #selector(openLoginTapped))
        NotificationCenter.default.addObserver(self, selector: #selector(removeLoginButton(_:)), name: .loginNotificationName, object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
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
}

extension HomeVC: HomeVMOutputProtocol {
    func didGetHomepage() {
        tableRefreshControl.endRefreshing()
        footerView.currentPageNumberLabel.text = String(currentPageNumber)
        tableView.reloadData()
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
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
}

//        nativeAdView.nativeAd = nativeAd
//
//
//        nativeAd.delegate = self
//
//        // Deactivate the height constraint that was set when the previous video ad loaded.
//        //        heightConstraint?.isActive = false
//
//        // Populate the native ad view with the native ad assets.
//        // The headline and mediaContent are guaranteed to be present in every native ad.
//        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
//        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
//
//        // Some native ads will include a video asset, while others do not. Apps can use the
//        // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
//        // UI accordingly.
//        //        let mediaContent = nativeAd.mediaContent
//        //        if mediaContent.hasVideoContent {
//        //          // By acting as the delegate to the GADVideoController, this ViewController receives messages
//        //          // about events in the video lifecycle.
//        //          mediaContent.videoController.delegate = self
//        //          videoStatusLabel.text = "Ad contains a video asset."
//        //        }
//        //        else {
//        //          videoStatusLabel.text = "Ad does not contain a video."
//        //        }
//
//        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
//        // ratio of the media it displays.
//        //        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
//        //          heightConstraint = NSLayoutConstraint(item: mediaView,
//        //                                                attribute: .height,
//        //                                                relatedBy: .equal,
//        //                                                toItem: mediaView,
//        //                                                attribute: .width,
//        //                                                multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
//        //                                                constant: 0)
//        //          heightConstraint?.isActive = true
//        //        }
//
//        // These assets are not guaranteed to be present. Check that they are before
//        // showing or hiding them.
//        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
//        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
//
//        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
//        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
//
//        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
//        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
//
//        //        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from:nativeAd.starRating)
//        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
//
//        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
//        nativeAdView.storeView?.isHidden = nativeAd.store == nil
//
//        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
//        nativeAdView.priceView?.isHidden = nativeAd.price == nil
//
//        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
//        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
//
//        // In order for the SDK to process touch events properly, user interaction should be disabled.
//        nativeAdView.callToActionView?.isUserInteractionEnabled = false
