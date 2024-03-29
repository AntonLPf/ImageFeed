//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 20.01.24.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileLogoutService = ProfileLogoutService.shared
    
    private static let profileImageWidth = 70.0
    
    private var profileImageServiceObserver: NSObjectProtocol?

    // MARK: - creating views
    
    private let profileImageView: UIImageView = {
        let profilePicture = UIImage(named: Constants.Picture.profilePicturePlaceHolder)
        let imageView = UIImageView(image: profilePicture)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = ProfileViewController.profileImageWidth / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.text = ""
        let profilePicture = UIImage(named: Constants.Picture.exitButton)
        button.setImage(profilePicture, for: .normal)
        button.addTarget(self, action: #selector(didExitButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = UIColor(named: Constants.Color.ypWhite)
        label.font = UIFont(name: Constants.Font.ysDisplayBold, size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = UIColor(named: Constants.Color.ypGray)
        label.font = UIFont(name: Constants.Font.ysDisplayMedium, size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "@Hello, World!"
        label.textColor = UIColor(named: Constants.Color.ypWhite)
        label.font = UIFont(name: Constants.Font.ysDisplayMedium, size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - container views
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private let vStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 8
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        addSubViews()
        applyConstraints()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            })
        updateAvatar()
        
        let profileService = ProfileService.shared
        if let profile = profileService.profile {
            updateProfileDetails(profile)
        }
    }
    
    // MARK: - assembling
    
    private func setupMainView() {
        view.backgroundColor = UIColor(named: Constants.Color.ypBlack)
    }
    
    private func addSubViews() {
        containerView.addSubview(profileImageView)
        containerView.addSubview(exitButton)
        
        vStack.addArrangedSubview(containerView)
        vStack.addArrangedSubview(nameLabel)
        vStack.addArrangedSubview(loginNameLabel)
        vStack.addArrangedSubview(descriptionLabel)
        
        view.addSubview(vStack)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 70),
            containerView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
            
            profileImageView.widthAnchor.constraint(equalToConstant: Self.profileImageWidth),
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.leadingAnchor.constraint(greaterThanOrEqualTo: profileImageView.trailingAnchor),
            exitButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            vStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - actions
    
    @objc private func didExitButtonTap() {
        let alertModel = AlertModel(title: "Пока, пока!", message: "Уверены что хотите выйти?", buttons: [
            AlertModel.Button(buttonText: "Да", actionHandler: { _ in
                self.profileLogoutService.logout()
                self.gotoSplashScreen()
            }, style: .destructive),
            AlertModel.Button(buttonText: "Нет", actionHandler: { _ in }, style: .default)
        ])
        presentAlert(model: alertModel)
    }
    
    // MARK: - Methods
    
    private func gotoSplashScreen() {
        guard let window = UIApplication.shared.windows.first else {
            preconditionFailure("Invalid Configuration")
        }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
    
    private func updateProfileDetails(_ profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageUrl = ProfileImageService.shared.avatarUrl,
            let imageUrl = URL(string: profileImageUrl)
        else { return }
        
        let placeHolderImage = UIImage(named: Constants.Picture.profilePicturePlaceHolder)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: imageUrl, placeholder: placeHolderImage)
    }
}

