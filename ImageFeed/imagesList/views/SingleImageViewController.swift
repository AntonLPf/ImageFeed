//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.01.24.
//

import UIKit
import Kingfisher

class SingleImageViewController: UIViewController {
    
    static private let shareButtonWidth: CGFloat = 51
    static private let backButtonWidth: CGFloat = 48
    
    @IBOutlet private weak var scrollView: UIScrollView?
    
    @IBOutlet private var imageView: UIImageView?
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.text = ""
        let picture = UIImage(named: Constants.Picture.shareButton)
        button.setImage(picture, for: .normal)
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        button.backgroundColor = UIColor(named: Constants.Color.ypBlack)
        button.layer.cornerRadius = Self.shareButtonWidth / 2
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let picture = UIImage(named: Constants.Picture.backward)

        button.titleLabel?.text = ""
        button.setImage(picture, for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    var imageUrl: URL? {
        didSet {
            guard isViewLoaded else { return }
            configureImageView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        applyConstraints()
        
        scrollView?.minimumZoomScale = 0.1
        scrollView?.maximumZoomScale = 1.25
        configureImageView()
    }
    
    private func addSubViews() {
        view.addSubview(shareButton)
        view.addSubview(backButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalToConstant: Self.shareButtonWidth),
            shareButton.heightAnchor.constraint(equalToConstant: Self.shareButtonWidth),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            backButton.widthAnchor.constraint(equalToConstant: Self.backButtonWidth),
            backButton.heightAnchor.constraint(equalToConstant: Self.backButtonWidth),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapShareButton(_ sender: Any) {
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
