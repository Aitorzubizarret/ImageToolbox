//
//  Coordinator.swift
//  ImageToolbox
//
//  Created by Aitor Zubizarreta on 31/1/23.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
    func showMainVC()
    func showCompareTwoVC()
    
}
