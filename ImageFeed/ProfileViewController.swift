//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 20.01.24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var profileImage: UIImageView?
    var nameLabel: UILabel?
    var loginNameLabel: UILabel?
    var descriptionLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
            
    private func createUI() {
        
        view.backgroundColor = UIColor(named: ProjectConstants.Color.ypBlack.rawValue)
        
        let profileImage = createProfileImageView()

        let exitButton = createExitButtonView()
        
        let nameLabel = createLabel(text: "Екатерина Новикова",
                                    projectFont: ProjectConstants.Font.ysDisplayBold,
                                    textColor: ProjectConstants.Color.ypWhite,
                                    fontSize: 23)
        
        let loginNameLabel = createLabel(text: "@ekaterina_nov",
                                         projectFont: .ysDisplayMedium,
                                         textColor: .ypGray,
                                         fontSize: 13)
        
        let descriptionLabel = createLabel(text: "Hello, World!",
                                           projectFont: .ysDisplayMedium,
                                           textColor: .ypWhite,
                                           fontSize: 13)
        
        let containerView = UIView()
        containerView.addSubview(profileImage)
        containerView.addSubview(exitButton)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let vStack = UIStackView(arrangedSubviews: [
            containerView,
            nameLabel,
            loginNameLabel,
            descriptionLabel
        ])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 8
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(vStack)

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 70),
            containerView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
            
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            profileImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            profileImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            exitButton.leadingAnchor.constraint(greaterThanOrEqualTo: profileImage.trailingAnchor),
            exitButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            vStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
        self.profileImage = profileImage
        self.nameLabel = nameLabel
        self.loginNameLabel = loginNameLabel
        self.descriptionLabel = descriptionLabel
    }
    
    private func createVStack() -> UIStackView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 8
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }
    
    private func createProfileImageView() -> UIImageView {
        let profilePicture = UIImage(named: ProjectConstants.Picture.profilePicture.rawValue)
        let imageView = UIImageView(image: profilePicture)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func createLabel(text: String,projectFont: ProjectConstants.Font, textColor: ProjectConstants.Color, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: textColor.rawValue)
        label.font = UIFont(name: projectFont.rawValue, size: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createExitButtonView() -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.text = ""
        let profilePicture = UIImage(named: ProjectConstants.Picture.exitButton.rawValue)
        button.setImage(profilePicture, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
}
