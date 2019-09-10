//
//  SwiftMessagesViewer.swift
//  eskiclient
//
//  Created by Onur Geneş on 10.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import SwiftEntryKit

final class SwiftMessagesViewer {
    
    static func success(title: String, backgroundColor: UIColor, message: String? = nil) {
        var attributes = EKAttributes.centerFloat
        attributes.entryBackground = .color(color: EKColor.init(light: backgroundColor, dark: backgroundColor))
        attributes.hapticFeedbackType = .success
        attributes.screenBackground = .visualEffect(style: .dark)
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        attributes.displayDuration = 0.7
        SwiftEntryKit.display(entry: SuccessView(title: title, message: message), using: attributes)
    }
    
    static func error(message: String) {
        var attributes = EKAttributes.bottomFloat
        attributes.entryBackground = .color(color: EKColor.init(light: .darkGray, dark: .darkGray))
        attributes.hapticFeedbackType = .error
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        attributes.displayDuration = 1.0
        SwiftEntryKit.display(entry: ErrorView(message: "Please try again later."), using: attributes)
    }
}
