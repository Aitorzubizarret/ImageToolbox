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
    
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
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
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Compare two images"
        
        setupView()
    }
    
    private func setupView() {
        // UIImageViews
        bottomImageView.backgroundColor = UIColor.red
        topImageView.backgroundColor = UIColor.blue
        
        setupPictureSelectionImageViews()
        
        // UISlider
        opacitySlider.value = 0
        topImageView.layer.opacity = opacitySlider.value
    }
    
    private func setupPictureSelectionImageViews() {
        // Corner Radius.
        bottomSelectedPhotoImageView.layer.cornerRadius = 4
        topSelectedPhotoImageView.layer.cornerRadius = 4
        
        // Border.
        bottomSelectedPhotoImageView.layer.borderWidth = 1
        bottomSelectedPhotoImageView.layer.borderColor = UIColor.black.cgColor
        
        topSelectedPhotoImageView.layer.borderWidth = 1
        topSelectedPhotoImageView.layer.borderColor = UIColor.black.cgColor
        
        // Content mode.
        bottomSelectedPhotoImageView.contentMode = .scaleAspectFill
        topSelectedPhotoImageView.contentMode = .scaleAspectFill
        
        // Gesture Recognizers.
        let selectBottomPhotoGR = UITapGestureRecognizer(target: self, action: #selector(selectBottomPicture))
        let selectTopPhotoGR = UITapGestureRecognizer(target: self, action: #selector(selectTopPicture))
        
        bottomSelectedPhotoImageView.addGestureRecognizer(selectBottomPhotoGR)
        bottomSelectedPhotoImageView.isUserInteractionEnabled = true
        
        topSelectedPhotoImageView.addGestureRecognizer(selectTopPhotoGR)
        topSelectedPhotoImageView.isUserInteractionEnabled = true
    }
    
    private func changeTopImageViewOpacity(slider: UISlider) {
        topImageView.layer.opacity = slider.value
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
                    switch self.selectedImageViewForPictureDisplay {
                    case .bottom:
                        self.bottomImageView.image = image
                        self.bottomSelectedPhotoImageView.image = image
                    case .top:
                        self.topImageView.image = image
                        self.topSelectedPhotoImageView.image = image
                    }
                }
            }
        }
    }
    
}
