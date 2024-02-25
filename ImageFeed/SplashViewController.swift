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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = oauth2Service.token {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: Constants.SegueId.showAuthenticationScreenSegue, sender: nil)
        }
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
        performSegue(withIdentifier: Constants.SegueId.showAuthenticationScreenSegue, sender: nil)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueId.showAuthenticationScreenSegue {
            if let navigationController = segue.destination as? UINavigationController,
               let viewController = navigationController.viewControllers[0] as? AuthViewController {
                viewController.delegate = self
            } else {
                preconditionFailure("Failed to prepare for \(Constants.SegueId.showAuthenticationScreenSegue)")
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
