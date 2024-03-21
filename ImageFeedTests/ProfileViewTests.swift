//
//  ProfileViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Антон Шишкин on 20.03.24.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    
    final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
        var view: ProfileViewControllerProtocol?
        
        var isViewDidLoadCalled = false
        
        var alertToShow: AlertModel?
        
        init(profileService: ProfileServiceProtocol,
             profileLogoutService: ProfileLogoutServiceProtocol, 
             profileImageService: ProfileImageServiceProtocol,
             alertPresenter: AlertPresenterProtocol,
             windowController: WindowControllerProtocol) {
            
        }
        
        func exitButtonDidTap() {
            
        }
        
        func viewDidLoad() {
            isViewDidLoadCalled = true
        }
        
    }
    
    final class WindowControllerSpy: WindowControllerProtocol {
        
        var setRootController: UIViewController?
        
        func setRootController(to vc: UIViewController) {
            setRootController = vc
        }
    }
    
    func testVCcallsPresenterViewDidload() {
        let presenter = ProfileViewPresenterSpy()
        let vc = ProfileViewController(presenter: presenter)
        
        _ = vc.view
        
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
    
    func testPresenterAlertModelText() {
        let presenter = ProfileViewPresenterSpy()
        let windowController = WindowControllerSpy()
        let vc = ProfileViewController(presenter: presenter)

        let expectedAlertModel = AlertModel(title: "Пока, пока!", message: "Уверены что хотите выйти?", buttons: [
            AlertModel.Button(buttonText: "Да", actionHandler: { _ in
                    
            }, style: .destructive),
            AlertModel.Button(buttonText: "Нет", actionHandler: { _ in }, style: .default)
        ])
    }
    
//    final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
//        var isPresentAlertCalled = false
//        
//        func presentAlert(model: AlertModel) {
//            isPresentAlertCalled = true
//        }
//    }
//    
//    var vc: ProfileViewController!
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        vc = ProfileViewController()
//    }
//
//    override func tearDownWithError() throws {
//        vc = nil
//        try super.tearDownWithError()
//    }
//
//    func testAlertConfiguration() throws {
//        
//        //given
//        let vc = ProfileViewController()
//        
//        //when
//        vc.didExitButtonTap()
//        
//        //then
//        
//    }

}
