//
//  HomeAdCell.swift
//  eskiclient
//
//  Created by Onur Geneş on 23.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import GoogleMobileAds
import TinyConstraints

final class HomeAdCell: UITableViewCell {
    
    var nativeAdView: GADUnifiedNativeAdView!
//    var heightConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        
        guard let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil), let adView = nibObjects.first as? GADUnifiedNativeAdView else {
            return
        }
        
        self.nativeAdView = adView
        addSubview(nativeAdView)
        nativeAdView.edgesToSuperview(insets: TinyEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        
//        heightConstraint = nativeAdView.mediaView?.height().first
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
