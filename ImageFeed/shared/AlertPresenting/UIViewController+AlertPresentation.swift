//
//  UIViewController+AlertPresentation.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 02.03.24.
//

import UIKit

extension UIViewController {
    func presentAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        if model.buttons.isEmpty {
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        } else {
            for button in model.buttons {
                let action = UIAlertAction(title: button.buttonText, style: .default, handler: button.actionHandler)
                alert.addAction(action)
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
