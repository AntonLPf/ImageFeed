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

final class WebViewViewController: UIViewController {
        
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - creating views
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: Constants.Picture.navBackButton)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = .ypBlack
        progressView.progress = 0.5
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .ypWhite
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainView()
        addSUbViews()
        applyConstraints()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: []) { [weak self] _, _ in
                 guard let self = self else { return }
                 DispatchQueue.main.async {
                     self.updateProgress()
                 }
             }

        if let request = getAuthRequest() {
            webView.load(request)
            webView.navigationDelegate = self
        }
    }
    
    // MARK: - assembling
    
    private func setupMainView() {
        view.backgroundColor = UIColor(named: Constants.Color.ypWhite)
    }
    
    private func addSUbViews() {
        view.addSubview(backButton)
        view.addSubview(progressBar)
        view.addSubview(webView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 64),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            progressBar.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            progressBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            webView.topAnchor.constraint(equalTo: progressBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    // MARK: - Methods
    
    @objc private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    private func updateProgress() {
        progressBar.progress = Float(webView.estimatedProgress)
        progressBar.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func getAuthRequest() -> URLRequest? {    
        try? CodeRequest.getCode.createURLRequest(token: nil)
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
