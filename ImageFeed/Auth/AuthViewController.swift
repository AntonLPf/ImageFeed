//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 05.02.24.
//

import UIKit

class AuthViewController: UIViewController {
    
    let showWebViewSegueId = "ShowWebView"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = Constants.SegueId.showWebViewSegue
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
        dismiss(animated: true)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    }
}
