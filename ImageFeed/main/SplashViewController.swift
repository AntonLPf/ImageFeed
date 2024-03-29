//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 13.02.24.
//

import UIKit

class SplashViewController: UIViewController {
    
    var oauth2Service: OAuth2ServiceProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.oauth2Service = OAuth2Service()
        
        if isAuthorized() {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: Constants.SegueId.showAuthenticationScreenSegue, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: Constants.StoryBoardViewId.tabBarViewController)
           
        window.rootViewController = tabBarController
    }
    
    private func navigateToAuthScreen() {
        performSegue(withIdentifier: Constants.SegueId.showAuthenticationScreenSegue, sender: nil)
    }
    
    private func isAuthorized() -> Bool {
        oauth2Service?.token != nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueId.showAuthenticationScreenSegue {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(Constants.SegueId.showAuthenticationScreenSegue)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        Task {
            do {
                try await oauth2Service?.fetchAuthToken(code: code)
                debugPrint(">>> Successfully Authorized")
                vc.dismiss(animated: true)
                switchToTabBarController()
            } catch {
                debugPrint(">>>Authorization Error")
                debugPrint(error)
            }
        }
    }
}
