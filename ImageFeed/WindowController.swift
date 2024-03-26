//
//  WindowController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 22.03.24.
//

import UIKit

protocol WindowControllerProtocol {
    func setRootController(to vc: UIViewController)
}

struct WindowController:WindowControllerProtocol {
    func setRootController(to vc: UIViewController) {
        guard let window = UIApplication.shared.windows.first else {
            preconditionFailure("Invalid WindowController Configuration")
        }
        window.rootViewController = vc
    }
}
