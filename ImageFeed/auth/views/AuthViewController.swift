//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 05.02.24.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
    func didAuthenticate(_ vc: AuthViewController)
}

class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTapButton() {
        showWebView()
    }
    
    private func showWebView() {
        let webViewController = WebViewViewController()
        webViewController.delegate = self
        webViewController.modalPresentationStyle = .fullScreen
        present(webViewController, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        delegate?.didAuthenticate(self)
    }
}
