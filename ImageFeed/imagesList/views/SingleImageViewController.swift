//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.01.24.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    static private let shareButtonWidth: CGFloat = 51
    static private let backButtonWidth: CGFloat = 48
    
    var imageUrl: URL? {
        didSet {
            guard isViewLoaded else { return }
            configureImageView()
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentMode = .scaleToFill
        view.minimumZoomScale = 0.1
        view.maximumZoomScale = 1.25
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: Constants.Picture.imagePlaceHolder)
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .center
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.backgroundColor = UIColor(named: Constants.Color.ypBlack)
        addSubViews()
        applyConstraints()
        configureImageView()
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        view.addSubview(shareButton)
        view.addSubview(backButton)
        scrollView.addSubview(imageView)
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
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func configureImageView() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success(let imageResult):
                self.imageView.contentMode = .scaleAspectFit
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showAlert()
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
                    actionHandler: nil,
                    style: .default),
                AlertModel.Button(
                    buttonText: "Повторить",
                    actionHandler: { _ in
                        self.configureImageView()
                    },
                    style: .default)
            ])
        self.presentAlert(model: alertModel)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
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
