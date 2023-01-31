//
//  MainCoordinator.swift
//  ImageToolbox
//
//  Created by Aitor Zubizarreta on 16/1/23.
//

import UIKit // For UINavigationController.

final class MainCoordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Methods
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

// MARK: - Coordinator

extension MainCoordinator: Coordinator {
    
    func start() {
        showMainVC()
    }
    
    func showMainVC() {
        let mainVC = MainViewController()
        mainVC.coordinator = self
        navigationController.pushViewController(mainVC, animated: true)
    }
    
    func showCompareTwoVC() {
        let compareTwoVC = CompareTwoViewController()
        compareTwoVC.coordinator = self
        navigationController.pushViewController(compareTwoVC, animated: true)
    }
    
}
