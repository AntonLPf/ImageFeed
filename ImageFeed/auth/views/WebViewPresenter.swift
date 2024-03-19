//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 19.03.24.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        if let request = getAuthRequest() {
            view?.load(request: request)
        }
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    private func getAuthRequest() -> URLRequest? {
        try? CodeRequest.getCode.createURLRequest(token: nil)
    }
}
