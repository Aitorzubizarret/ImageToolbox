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
    var originalScale: CGFloat
    var currentScale: CGFloat
    
    // MARK: - Methods
    
    init(image: UIImage) {
        self.image = image
        self.originalScale = 1
        self.currentScale = 1
        
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
