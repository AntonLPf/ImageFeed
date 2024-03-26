//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Антон Шишкин on 25.03.24.
//

import XCTest
@testable import ImageFeed

final class ImageListTests: XCTestCase {
    
    final class ImageListServiseSpy: ImageListServiceProtocol {
        var photos: [Photo] = []
        
        var isFetchPhotosNextPageCalled = false
        var isChangingLikeCalled = false
        
        func fetchPhotosNextPage(_ token: String, _ completion: @escaping (Result<[ImageFeed.Photo], any Error>) -> Void) {
            isFetchPhotosNextPageCalled = true
        }
        
        func changeLike(token: String, photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
            isChangingLikeCalled = true
        }
        
        func reset() { }
    }
    
    final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
        var presenter: ImageListPresenterProtocol?

        var isShowBlockingLoaderCalled = false
        
        required init(presenter: ImageListPresenterProtocol? = nil) {
            self.presenter = presenter
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        func updateTableViewAnimated(photoIndexes: Range<Int>) {
            
        }

        func showBlockingLoader() {
            isShowBlockingLoaderCalled = true
        }
        
        func hideBlockingLoader() { }
    }

    func testVCcallsPresenterViewDidload() {
        final class ImageListPresenterSpy: ImageListPresenter {
            var isViewDidLoadCalled = false
                            
            override func viewDidLoad() {
                isViewDidLoadCalled = true
            }
            
        }
        
        let presenter = ImageListPresenterSpy()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        vc.presenter = presenter
        presenter.view = vc
        
        _ = vc.view
        
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
    
    func testPresenterCallsImageListServiseforFetchingFotos() {
        let oauthService = OAuth2Service.shared
        oauthService.token = "tokenStub"
        
        let imageService = ImageListServiseSpy()
        
        let presenter = ImageListPresenter(imagesListService: imageService, oauthService: oauthService)
        presenter.fetchMorePhotos()
        XCTAssertTrue(imageService.isFetchPhotosNextPageCalled)
    }
    
    func testPresenterCallsImageListServiseChangingLike() {
        let oauthService = OAuth2Service.shared
        oauthService.token = "tokenStub"
        
        let imageService = ImageListServiseSpy()
        
        let presenter = ImageListPresenter(imagesListService: imageService, oauthService: oauthService)
        presenter.changeLike(photoId: "", isLike: true) { _ in }
        XCTAssertTrue(imageService.isChangingLikeCalled)
    }
    
    func testPresenterCallsShowBlockingLoaderAtViewDidLoad() {
        var presenter: ImageListPresenterProtocol = ImageListPresenter()
        let vc = ImagesListViewControllerSpy(presenter: presenter)
        vc.presenter = presenter
        presenter.view = vc
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(vc.isShowBlockingLoaderCalled)
    }
}
