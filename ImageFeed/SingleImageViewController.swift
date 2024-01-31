//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.01.24.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView?
    
    @IBOutlet private weak var shareButton: UIButton?
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            if let imageView, let image {
                imageView.image = image
                rescaleAndCenterImageInScrollView(image: image)
            }
        }
    }
    
    @IBOutlet var imageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let shareButton {
            shareButton.layer.cornerRadius = shareButton.frame.width / 2
            shareButton.layer.masksToBounds = true
        }
        scrollView?.minimumZoomScale = 0.1
        scrollView?.maximumZoomScale = 1.25
        if let imageView, let image {
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
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
