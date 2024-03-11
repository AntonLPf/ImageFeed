//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.01.24.
//

import UIKit
import Kingfisher

class SingleImageViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView?
    
    @IBOutlet private weak var shareButton: UIButton?
    
    @IBOutlet private var imageView: UIImageView?
    
    var imageUrl: URL? {
        didSet {
            guard isViewLoaded else { return }
            configureImageView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let shareButton {
            shareButton.layer.cornerRadius = shareButton.frame.width / 2
            shareButton.layer.masksToBounds = true
        }
        scrollView?.minimumZoomScale = 0.1
        scrollView?.maximumZoomScale = 1.25
        configureImageView()
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = imageView?.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func configureImageView() {
        if let imageView {
            UIBlockingProgressHUD.show()
            imageView.kf.setImage(with: imageUrl) { [weak self] result in
                guard let self = self else { return }
                UIBlockingProgressHUD.dismiss()

                switch result {
                case .success(let imageResult):
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                case .failure:
                    self.showAlert()
                }
            }
        }
    }
    
    private func showAlert() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            buttons: [
                AlertModel.Button(
                    buttonText: "Не надо",
                    actionHandler: nil),
                AlertModel.Button(
                    buttonText: "Повторить",
                    actionHandler: { _ in
                        self.configureImageView()
                    })
            ])
        self.presentAlert(model: alertModel)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        guard let scrollView else { return }
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
