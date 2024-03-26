//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 22.03.24.
//

import UIKit

protocol AlertPresenterProtocol {
    func presentAlert(model: AlertModel,on vc: AnyObject)
}

struct AlertPresenter: AlertPresenterProtocol {
    func presentAlert(model: AlertModel,on vc: AnyObject) {
        guard let vc = vc as? UIViewController else { return }
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        if model.buttons.isEmpty {
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        } else {
            for button in model.buttons {
                let action = UIAlertAction(title: button.buttonText, style: button.style, handler: button.actionHandler)
                alert.addAction(action)
            }
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
}
