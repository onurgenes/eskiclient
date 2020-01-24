//
//  UIImageFromView.swift
//  eskiclient
//
//  Created by Onur Geneş on 24.01.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import UIKit

extension UIImage{
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let finalImage = image else {
            self.init()
            return
        }
        self.init(cgImage: (finalImage.cgImage)!)
    }
}
