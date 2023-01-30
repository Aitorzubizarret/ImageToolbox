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
    
    var opacity: Float = 1 {
        didSet {
            layer.opacity = opacity
        }
    }
    
    // MARK: - Methods
    
    init(image: UIImage, frameWidth: CGFloat, frameHeight: CGFloat) {
        self.image = image
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        
        fixImageOrientation()
        updateFrameSize(frameWidth: self.frameWidth, frameHeight: self.frameHeight)
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
    
    // Updates the CALayer frame size. Used when the devices orientation changes (portrait to landscape or viceversa).
    func updateFrameSize(frameWidth: CGFloat, frameHeight: CGFloat) {
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        
        createLayer()
    }
    
    func updateOpacity(opacity: Float) {
        self.opacity = opacity
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
    }
    
}
