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
    
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    
    // MARK: - Methods
    
    init(image: UIImage, frameWidth: CGFloat, frameHeight: CGFloat) {
        self.image = image
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        
        fixImageOrientation()
        createLayer()
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
    
    private func createLayer() {
        // Sizes and scales.
        let pictureWidth: CGFloat = image.size.width
        let pictureHeight: CGFloat = image.size.height
        
        let widthScale: CGFloat = pictureWidth / frameWidth
        let heightScale: CGFloat = pictureHeight / frameHeight
        
        // Checks which scale value is better for the picture, taking into account the frame size.
        if (pictureWidth / widthScale <= frameWidth) && (pictureHeight / widthScale <= frameHeight) {
            originalScale = widthScale
            currentScale = widthScale
        } else {
            originalScale = heightScale
            currentScale = heightScale
        }
        
        // Create the CALayer.
        layer.frame = CGRect(x: 0,
                             y: 0,
                             width: frameWidth,
                             height: frameHeight)
        layer.contents = image.cgImage
        layer.contentsGravity = .center
        layer.contentsScale = currentScale
        layer.opacity = 1
    }
    
}
