//
//  CompareTwoViewController.swift
//  ImageToolbox
//
//  Created by Aitor Zubizarreta on 16/1/23.
//

import UIKit

class CompareTwoViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var opacitySlider: UISlider!
    @IBAction func opacitySliderMoving(_ sender: Any) {
        changeTopImageViewOpacity(slider: sender as! UISlider)
    }
    
    // MARK: - Properties
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Compare two images"
        
        setupView()
    }
    
    private func setupView() {
        bottomImageView.backgroundColor = UIColor.red
        topImageView.backgroundColor = UIColor.blue
        
        opacitySlider.value = 0
        topImageView.layer.opacity = opacitySlider.value
    }
    
    private func changeTopImageViewOpacity(slider: UISlider) {
        topImageView.layer.opacity = slider.value
    }
    
}
