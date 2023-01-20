//
//  UIImage+Extension.swift
//  ImageToolbox
//
//  Created by Aitor Zubizarreta on 20/1/23.
//

import UIKit

extension UIImage {
    
    func correctOrientation() -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
