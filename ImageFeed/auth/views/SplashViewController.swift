//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 13.02.24.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let oauth2Service: OAuth2ServiceProtocol = OAuth2Service.shared
    
    // MARK: - creating views
    
    private let logoImageView: UIImageView = {
        let practicumPicture = UIImage(named: Constants.Picture.practicumLogo)
        let imageView = UIImageView(image: practicumPicture)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addSubViews()
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = oauth2Service.token {
            fetchProfile(token)
        } else {
            navigateToAuthScreen()
        }
    }
    
    // MARK: - assembling
    
    private func addSubViews() {
        view.addSubview(logoImageView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 76),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1),
            
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            preconditionFailure("Invalid Configuration")
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: Constants.StoryBoardViewId.tabBarViewController)
           
        window.rootViewController = tabBarController
    }
    
    private func navigateToAuthScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard 
            let authNavigationController = storyboard.instantiateViewController(withIdentifier: "AuthNavigationController") as? AuthNavigationController,
            let authViewController = authNavigationController.viewControllers.first as? AuthViewController
        else {
            preconditionFailure("Failed to setup AuthViewController")
        }
        
        authNavigationController.modalPresentationStyle = .fullScreen
        authViewController.delegate = self
        present(authNavigationController, animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        self.fetchOAuthToken(code)
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = oauth2Service.token else { return }
        
        fetchProfile(token)
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success:
                    if let token = self.oauth2Service.token {
                        self.fetchProfile(token)
                    }
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    break
                }
            }
        }
    }
        
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(token, username: profile.username) { _ in }
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                }
            case .failure:
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                }
                #warning("Покажите ошибку получения профиля")
                break
            }
        }
    }
}
