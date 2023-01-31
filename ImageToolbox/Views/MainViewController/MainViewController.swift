//
//  MainViewController.swift
//  ImageToolbox
//
//  Created by Aitor Zubizarreta on 15/1/23.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var compareTwoButton: UIButton!
    @IBAction func compareTwoButtonTapped(_ sender: Any) {
        navigateToCompareTwoVC()
    }
    
    // MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Image Toolbox"
    }
    
    private func navigateToCompareTwoVC() {        
        coordinator?.showCompareTwoVC()
    }

}
