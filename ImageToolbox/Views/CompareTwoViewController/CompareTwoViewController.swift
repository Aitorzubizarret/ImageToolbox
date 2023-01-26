//
//  CompareTwoViewController.swift
//  ImageToolbox
//
//  Created by Aitor Zubizarreta on 16/1/23.
//

import UIKit
import PhotosUI // To display and select pictures from  Photos Library.

class CompareTwoViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var controlsView: UIView!
    
    @IBOutlet weak var opacitySlider: UISlider!
    @IBAction func opacitySliderMoving(_ sender: Any) {
        changeTopImageViewOpacity(slider: sender as! UISlider)
    }
    
    @IBOutlet weak var bottomSelectedPhotoImageView: UIImageView!
    @IBOutlet weak var topSelectedPhotoImageView: UIImageView!
    
    // MARK: - Properties
    
    enum PicturePosition {
        case bottom
        case top
    }
    
    var photoPickerConf: PHPickerConfiguration {
        var phPickerConf = PHPickerConfiguration()
        phPickerConf.selectionLimit = 1
        phPickerConf.filter = PHPickerFilter.any(of: [.images, .screenshots])
        return phPickerConf
    }
    var photoPickerVC: PHPickerViewController {
        let phPickerVC = PHPickerViewController(configuration: photoPickerConf)
        phPickerVC.delegate = self
        return phPickerVC
    }
    
    var selectedImageViewForPictureDisplay: PicturePosition = .bottom
    
    var bottomPictureLayer = CALayer()
    var topPictureLayer = CALayer()
    
    var bottomPicture: Picture?
    var topPicture: Picture?
    
    var frameWidth: CGFloat = 0
    var frameHeight: CGFloat = 0
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Compare two images"
        
        setupView()
        setupPictureSelectionImageViews()
    }
    
    override func viewDidLayoutSubviews() {
        frameWidth = imageView.frame.width
        frameHeight = imageView.frame.height
        
        setupControlsView()
    }
    
    private func setupView() {
        // UISlider
        opacitySlider.value = 0
        topPictureLayer.opacity = opacitySlider.value
        
        // Pinch Gesture Recognizer.
        imageView.isUserInteractionEnabled = true
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(sender: )))
        imageView.addGestureRecognizer(pinchGR)
    }
    
    private func setupControlsView() {
        let borderWidth: CGFloat = 1
        let borderColor: CGColor = UIColor.systemGray3.cgColor
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: controlsView.frame.width, height: borderWidth)
        topBorder.backgroundColor = borderColor
        
        controlsView.layer.addSublayer(topBorder)
    }
    
    private func setupPictureSelectionImageViews() {
        // Content mode.
        bottomSelectedPhotoImageView.contentMode = .scaleAspectFill
        topSelectedPhotoImageView.contentMode = .scaleAspectFill
        
        // Image.
        bottomSelectedPhotoImageView.image = UIImage(named: "addImagePlaceholder")
        topSelectedPhotoImageView.image = UIImage(named: "addImagePlaceholder")
        
        // Corner Radius.
        bottomSelectedPhotoImageView.layer.cornerRadius = 4
        topSelectedPhotoImageView.layer.cornerRadius = 4
        
        // Border.
        bottomSelectedPhotoImageView.layer.borderWidth = 1
        bottomSelectedPhotoImageView.layer.borderColor = UIColor.systemGray2.cgColor
        
        topSelectedPhotoImageView.layer.borderWidth = 1
        topSelectedPhotoImageView.layer.borderColor = UIColor.systemGray2.cgColor
        
        // Gesture Recognizers.
        let selectBottomPhotoGR = UITapGestureRecognizer(target: self, action: #selector(selectBottomPicture))
        let selectTopPhotoGR = UITapGestureRecognizer(target: self, action: #selector(selectTopPicture))
        
        bottomSelectedPhotoImageView.addGestureRecognizer(selectBottomPhotoGR)
        bottomSelectedPhotoImageView.isUserInteractionEnabled = true
        
        topSelectedPhotoImageView.addGestureRecognizer(selectTopPhotoGR)
        topSelectedPhotoImageView.isUserInteractionEnabled = true
    }
    
    private func changeTopImageViewOpacity(slider: UISlider) {
        topPictureLayer.opacity = slider.value
    }
    
    private func displayPictureInImageView(picture: UIImage) {
        let currentPicture = Picture(image: picture)
        
        // Delete all previous layers.
        imageView.layer.sublayers?.removeAll()
        
        switch self.selectedImageViewForPictureDisplay {
        case .bottom:
            bottomPicture = currentPicture
        case .top:
            topPicture = currentPicture
        }
        
        // Sizes.
        let pictureWidth: CGFloat = currentPicture.image.size.width
        let pictureHeight: CGFloat = currentPicture.image.size.height
        
        let widthScale: CGFloat = pictureWidth / frameWidth
        let heightScale: CGFloat = pictureHeight / frameHeight
        
        // Checks which scale value is better for the picture, taking into account the frame size.
        if (pictureWidth / widthScale <= frameWidth) && (pictureHeight / widthScale <= frameHeight) {
            currentPicture.originalScale = widthScale
            currentPicture.currentScale = widthScale
        } else {
            currentPicture.originalScale = heightScale
            currentPicture.currentScale = heightScale
        }
        
        resizeDisplayedPictures(picturePosition: .bottom)
        resizeDisplayedPictures(picturePosition: .top)
    }
    
    private func resizeDisplayedPictures(picturePosition: PicturePosition) {
        switch picturePosition {
        case .bottom:
            if let bottomPicture = bottomPicture {
                // Bottom Picture Layer.
                bottomPictureLayer.frame = CGRect(x: 0,
                                                  y: 0,
                                                  width: frameWidth,
                                                  height: frameHeight)
                bottomPictureLayer.contents = bottomPicture.image.cgImage
                bottomPictureLayer.contentsGravity = .center
                bottomPictureLayer.contentsScale = bottomPicture.currentScale
                
                imageView.layer.addSublayer(bottomPictureLayer)
                
                // Top Picture Layer.
                imageView.layer.addSublayer(topPictureLayer)
                
                self.bottomSelectedPhotoImageView.image = bottomPicture.image
            }
        case .top:
            if let topPicture = topPicture {
                // Bottom Picture Layer.
                imageView.layer.addSublayer(bottomPictureLayer)
                
                // Top Picture Layer.
                topPictureLayer.frame = CGRect(x: 0,
                                               y: 0,
                                               width: frameWidth,
                                               height: frameHeight)
                topPictureLayer.contents = topPicture.image.cgImage
                topPictureLayer.contentsGravity = .center
                topPictureLayer.contentsScale = topPicture.currentScale
                
                imageView.layer.addSublayer(topPictureLayer)
                
                self.topSelectedPhotoImageView.image = topPicture.image
            }
        }
    }
    
    @objc private func selectBottomPicture() {
        selectedImageViewForPictureDisplay = .bottom
        present(photoPickerVC, animated: true)
    }
    
    @objc private func selectTopPicture() {
        selectedImageViewForPictureDisplay = .top
        present(photoPickerVC, animated: true)
    }
    
    @objc private func pinchImage(sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            guard let bottomPicture = bottomPicture,
                  let topPicture = topPicture else { return }
            
            /// The value received by the PinchGR, makes the image smaller when zoom-in, and bigger when zoom-out.
            /// To "fix" this :
            /// Zoom-in   => Received value 1,014 => Correct value => 0,986 (Smaller than 1) => 2 - 1,014
            /// Zoom-out => Received value 0,98   => Correct value => 1,02 (Bigger than 1) => 2 - 0,98
            var newBottomPictureScale = bottomPicture.currentScale * (2 - sender.scale)
            var newTopPictureScale = topPicture.currentScale * (2 - sender.scale)
            
            if newBottomPictureScale < 1 {
                newBottomPictureScale = 1
            }
            if newTopPictureScale < 1 {
                newTopPictureScale = 1
            }
            
            if newBottomPictureScale > (bottomPicture.originalScale + 2) {
                newBottomPictureScale = bottomPicture.originalScale + 2
            }
            if newTopPictureScale > (topPicture.originalScale + 2) {
                newTopPictureScale = topPicture.originalScale + 2
            }
            
            bottomPicture.currentScale = newBottomPictureScale
            topPicture.currentScale = newBottomPictureScale
            
            sender.scale = 1
            
            resizeDisplayedPictures(picturePosition: .bottom)
            resizeDisplayedPictures(picturePosition: .top)
        }
    }
    
}

// PhotosUI, PHPickerViewControllerDelegate

extension CompareTwoViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                
                guard let image = reading as? UIImage,
                      error == nil else { return }
                
                DispatchQueue.main.async {
                    self.displayPictureInImageView(picture: image)
                }
            }
        }
    }
    
}
