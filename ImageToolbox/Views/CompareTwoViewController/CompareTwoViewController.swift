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
        let slider = sender as! UISlider
        topLayerOpacity = slider.value
    }
    
    @IBOutlet weak var bottomSelectedPhotoImageView: UIImageView!
    @IBOutlet weak var topSelectedPhotoImageView: UIImageView!
    
    // MARK: - Properties
    
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
    
    var pictures: [Picture] = []
    
    var topLayerOpacity: Float = 0 {
        didSet {
            changeTopImageViewOpacity()
        }
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Compare two images"
        
        setupView()
        setupPictureSelectionImageViews()
    }
    
    override func viewDidLayoutSubviews() {
        setupControlsView()
    }
    
    private func setupView() {
        // UISlider
        opacitySlider.value = topLayerOpacity
        
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
    
    private func changeTopImageViewOpacity() {
        if pictures.count == 2 {
            let topPicture = pictures[1]
            topPicture.layer.opacity = topLayerOpacity
        }
    }
    
    private func displayPictureInImageView(picture: UIImage) {
        let currentPicture = Picture(image: picture, frameWidth: imageView.frame.width, frameHeight: imageView.frame.height)
        pictures.append(currentPicture)
        imageView.layer.addSublayer(currentPicture.layer)
        
        switch pictures.count {
        case 1:
            bottomSelectedPhotoImageView.image = pictures[0].image
        case 2:
            currentPicture.layer.opacity = topLayerOpacity
            topSelectedPhotoImageView.image = pictures[1].image
        default:
            print("")
        }
    }
    
    private func resizeDisplayedPictures() {
        switch pictures.count {
        case 1:
            let bottomPicture = pictures[0]
            bottomPicture.layer.contentsScale = bottomPicture.currentScale
        case 2:
            let bottomPicture = pictures[0]
            bottomPicture.layer.contentsScale = bottomPicture.currentScale
            
            let topPicture = pictures[1]
            topPicture.layer.contentsScale = topPicture.currentScale
            topPicture.layer.opacity = topLayerOpacity
            
            topSelectedPhotoImageView.image = topPicture.image
        default:
            print("")
        }
    }
    
    @objc private func selectBottomPicture() {
        present(photoPickerVC, animated: true)
    }
    
    @objc private func selectTopPicture() {
        present(photoPickerVC, animated: true)
    }
    
    @objc private func pinchImage(sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            if pictures.count == 2 {
                let bottomPicture = pictures[0]
                let topPicture = pictures[1]
                
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
                
                resizeDisplayedPictures()
            }
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
