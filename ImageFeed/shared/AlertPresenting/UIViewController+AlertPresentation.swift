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
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: model.actionHandler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
