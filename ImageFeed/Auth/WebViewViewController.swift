//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 05.02.24.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let request = getAuthRequest() {
            webView.load(request)
            webView.navigationDelegate = self
        }
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) { 
        
    }
    
    private func getAuthRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.Api.authorizingUrlString) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.Api.accesKey),
            URLQueryItem(name: "redirect_uri", value: Constants.Api.redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.Api.accessScope)
        ]
        guard let url = urlComponents.url else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
