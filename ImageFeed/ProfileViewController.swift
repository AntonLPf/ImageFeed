//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 20.01.24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - creating views
    
    private let profileImage: UIImageView = {
        let profilePicture = UIImage(named: ProjectConstants.Picture.profilePicture)
        let imageView = UIImageView(image: profilePicture)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.text = ""
        let profilePicture = UIImage(named: ProjectConstants.Picture.exitButton)
        button.setImage(profilePicture, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = UIColor(named: ProjectConstants.Color.ypWhite)
        label.font = UIFont(name: ProjectConstants.Font.ysDisplayBold, size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = UIColor(named: ProjectConstants.Color.ypGray)
        label.font = UIFont(name: ProjectConstants.Font.ysDisplayMedium, size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "@Hello, World!"
        label.textColor = UIColor(named: ProjectConstants.Color.ypWhite)
        label.font = UIFont(name: ProjectConstants.Font.ysDisplayMedium, size: 13)
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
    }
    
    // MARK: - assembling
    
    private func setupMainView() {
        view.backgroundColor = UIColor(named: ProjectConstants.Color.ypBlack)
    }
    
    private func addSubViews() {
        containerView.addSubview(profileImage)
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
    }
}
