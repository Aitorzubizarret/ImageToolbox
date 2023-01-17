//
//  MainCoordinator.swift
//  ImageToolbox
//
//  Created by Aitor Zubizarreta on 16/1/23.
//

import UIKit // For UINavigationController.

class MainCoordinator {
    
    // MARK: - Properties
    
    private let navController = UINavigationController()
    
    var rootViewController: UIViewController {
        return navController
    }
    
    // MARK: - Methods
    
    func start() {
        showMainVC()
    }
    
    private func showMainVC() {
        // Create an instance of the main view controller.
        let mainVC = MainViewController()
        
        navController.pushViewController(mainVC, animated: true)
    }
    
}
