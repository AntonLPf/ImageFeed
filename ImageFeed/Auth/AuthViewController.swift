//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 05.02.24.
//

import UIKit

class AuthViewController: UIViewController {
    
    let showWebViewSegueId = ProjectConstants.SegueId.showWebViewSegue
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = ProjectConstants.SegueId.showWebViewSegue
        if segue.identifier == segueId {
            guard let webViewViewController = segue.destination as? WebViewViewController else { fatalError("Failed to prepare for \(segueId)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        Task {
            do {
                let oauth2Service = OAuth2Service()
                let token = try await oauth2Service.fetchAuthToken(code: code)
                debugPrint(">>> Successfully Authorized")
                let userDefaultsManager = UserDefaultsManager()
                try? userDefaultsManager.save(codable: token, key: ProjectConstants.UserDefaultsKey.token.rawValue)
                dismiss(animated: true)
            } catch {
                debugPrint(">>>Authorization Error")
                debugPrint(error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
