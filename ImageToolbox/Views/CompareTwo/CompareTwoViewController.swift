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
        opacitySlider.value = 0
        topPictureLayer.opacity = opacitySlider.value
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
        // Delete all previous layers.
        imageView.layer.sublayers?.removeAll()
        
        // Sizes.
        let pictureWidth: CGFloat = picture.size.width
        let pictureHeight: CGFloat = picture.size.height
        let frameWidth: CGFloat = imageView.frame.width
        let frameHeight: CGFloat = imageView.frame.height
        
        // Checks if the width of a picture is bigger than its height.
        let scale: CGFloat = (pictureWidth > pictureHeight) ? (pictureWidth / frameWidth) : (pictureHeight / frameHeight)
        
        switch self.selectedImageViewForPictureDisplay {
        case .bottom:
            // Bottom Picture Layer.
            bottomPictureLayer.frame = CGRect(x: 0,
                                              y: 0,
                                              width: frameWidth,
                                              height: frameHeight)
            bottomPictureLayer.contents = picture.cgImage
            bottomPictureLayer.contentsGravity = .center
            bottomPictureLayer.contentsScale = scale
            
            imageView.layer.addSublayer(bottomPictureLayer)
            
            // Top Picture Layer.
            imageView.layer.addSublayer(topPictureLayer)
            
            self.bottomSelectedPhotoImageView.image = picture
        case .top:
            // Bottom Picture Layer.
            imageView.layer.addSublayer(bottomPictureLayer)
            
            // Top Picture Layer.
            topPictureLayer.frame = CGRect(x: 0,
                                           y: 0,
                                           width: frameWidth,
                                           height: frameHeight)
            topPictureLayer.contents = picture.cgImage
            topPictureLayer.contentsGravity = .center
            topPictureLayer.contentsScale = scale
            
            imageView.layer.addSublayer(topPictureLayer)
            
            self.topSelectedPhotoImageView.image = picture
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
