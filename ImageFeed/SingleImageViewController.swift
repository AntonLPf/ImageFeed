//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.01.24.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }

}
