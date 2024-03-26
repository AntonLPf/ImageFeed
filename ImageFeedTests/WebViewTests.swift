//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Антон Шишкин on 03.03.24.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    final class WebViewPresenterSpy: WebViewPresenterProtocol {
        var viewDidLoadCalled: Bool = false
        var view: WebViewViewControllerProtocol?
        
        func viewDidLoad() {
            viewDidLoadCalled = true
        }
        
        func didUpdateProgressValue(_ newValue: Double) {
            
        }
        
        func code(from url: URL) -> String? {
            nil
        }
    }
    
    final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
        var presenter: WebViewPresenterProtocol?

        var loadRequestCalled: Bool = false

        func load(request: URLRequest) {
            loadRequestCalled = true
        }

        func setProgressValue(_ newValue: Float) {

        }

        func setProgressHidden(_ isHidden: Bool) {

        }
    }
    
    func testViewControllerCallsViewDidLoad() {
        
        //given
        let vc = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        _ = vc.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        
        //given
        let vc = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(vc.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        
        //given
        let authHelper = AuthHelper() //Dummy
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        
        //given
        let configuration = Constants.AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let urlRequest = authHelper.authRequest()!
        let urlString = urlRequest.url!.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        
        //given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, "test code")
    }

}
