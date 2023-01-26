//
//  Picture.swift
//  ImageToolbox
//
//  Created by Aitor Zubizarreta on 25/1/23.
//

import UIKit

final class Picture {
    
    // MARK: - Properties
    
    var image: UIImage
    
    var layer = CALayer()
    
    var originalScale: CGFloat = 1
    var currentScale: CGFloat = 1
    
    // MARK: - Methods
    
    init(image: UIImage) {
        self.image = image
        
        fixImageOrientation()
    }
    
    // Checks picture orientation and corrects it by rotating.
    private func fixImageOrientation() {
        switch image.imageOrientation {
        case .left, .right, .down:
            image = image.correctOrientation() ?? image
        default:
            print("")
        }
    }
    
    func setOriginalScale(scale: CGFloat) {
        self.originalScale = scale
    }
    
}
