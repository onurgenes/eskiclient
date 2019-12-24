//
//  SingleEntryView.swift
//  eskiclient
//
//  Created by Onur Geneş on 24.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

final class SingleEntryView: UIView {
    
    lazy var insetView: UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var contentTextView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = true
        tv.dataDetectorTypes = [.link]
        tv.isEditable = false
        return tv
    }()
    
    lazy var dateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    
    lazy var authorButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        btn.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
        btn.setTitleColor(UIColor(red: 92/255, green: 193/255, blue: 76/255, alpha: 1.0), for: .normal)
        btn.titleLabel?.numberOfLines = 0
        return btn
    }()
    
    lazy var favoriteCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.text = "0 favori"
        return lbl
    }()
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [favoriteCountLabel, authorButton])
        sv.axis = .horizontal
        sv.spacing = 4
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var infoStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dateButton, bottomStackView])
        sv.axis = .vertical
        sv.distribution = .fill
        return sv
    }()
    
    convenience init() {
        self.init(frame: .zero)
        
        addSubview(insetView)
        insetView.edgesToSuperview(insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        
        insetView.addSubview(contentTextView)
        insetView.addSubview(infoStackView)
        
        infoStackView.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        
        contentTextView.edgesToSuperview(excluding: .bottom, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        contentTextView.bottomToTop(of: infoStackView, offset: -10)
        
        insetView.layer.cornerRadius = 8
        insetView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1) : .white
        contentTextView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1) : .white
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        insetView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1) : .white
        backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        contentTextView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1) : .white
    }
}
