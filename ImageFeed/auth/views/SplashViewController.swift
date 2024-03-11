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
            UIBlockingProgressHUD.show()
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
    
    // MARK: - methods
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            preconditionFailure("Invalid Configuration")
        }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    private func navigateToAuthScreen() {
        let authViewController = AuthViewController()
        authViewController.modalPresentationStyle = .fullScreen
        authViewController.delegate = self
        present(authViewController, animated: true)
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let token = self.oauth2Service.token {
                        self.fetchProfile(token)
                    }
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    let alertModel = AlertModel(
                        title: "Что-то пошло не так",
                        message: "Не удалось войти в систему",
                        buttons: [
                            AlertModel.Button(
                                buttonText: "OK", 
                                actionHandler: nil)
                        ])
                    self.presentedViewController?.presentAlert(model: alertModel)
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
                    let model = AlertModel(
                        title: "Что-то пошло не так",
                        message: "Не удалось получить данные",
                        buttons: [
                            AlertModel.Button(
                                buttonText: "OK",
                                actionHandler: nil)
                        ])
                    self.presentAlert(model: model)
                }
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        self.fetchOAuthToken(code)
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        
        guard let token = oauth2Service.token else {
            vc.dismiss(animated: true)
            return
        }
        
        fetchProfile(token)
    }
}
