//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 02.03.24.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttons: [Button]
    
    struct Button {
        let buttonText: String
        let actionHandler: ((_: UIAlertAction) -> Void)?
    }
}
