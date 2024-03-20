//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Антон Шишкин on 03.03.24.
//

@testable import ImageFeed
import XCTest

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

final class WebViewTests: XCTestCase {
    
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
    
//    func testFetchPhotos() {
//        let service = ImagesListService.shared
//        
//        let expectation = self.expectation(description: "Wait for Notification")
//        
//        NotificationCenter.default.addObserver(
//            forName: ImagesListService.didChangeNotification,
//            object: nil,
//            queue: .main) { _ in
//                expectation.fulfill()
//            }
//        
//        service.fetchPhotosNextPage(<#T##token: String##String#>, <#T##completion: (Result<[Photo], Error>) -> Void##(Result<[Photo], Error>) -> Void#>)
//        wait(for: [expectation], timeout: 10)
//        
//        XCTAssertEqual(service.photos.count, 10)
//    }
}
