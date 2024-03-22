//
//  ProfileViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Антон Шишкин on 20.03.24.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    
    class ProfileViewControllerSpy: ProfileViewController {
        var updateProfileDetailsCalled = false
        var updateAvatarCalled = false
        
        override func updateProfileDetails(with profile: ImageFeed.Profile) {
            updateProfileDetailsCalled = true
        }
        
        override func updateAvatar(avatarUrl: URL?) {
            updateAvatarCalled = true
        }
    }
    
    func testVCcallsPresenterViewDidload() {
        final class ProfileViewPresenterSpy: ProfileViewPresenter {
            var isViewDidLoadCalled = false
                            
            override func viewDidLoad() {
                isViewDidLoadCalled = true
            }
            
        }
        
        let presenter = ProfileViewPresenterSpy()
        let vc = ProfileViewController(presenter: presenter)
        
        _ = vc.view
        
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
    
    func testPresenterCallsAlertPresenterAfterExitButtonDidTap() {
        
        final class AlertPresenterSpy: AlertPresenterProtocol {
            var presentAlertDidCall = false
            
            func presentAlert(model: AlertModel, on vc: AnyObject) {
                presentAlertDidCall = true
            }
        }
        
        let alertPresenter = AlertPresenterSpy()
        let presenter = ProfileViewPresenter(alertPresenter: alertPresenter)
        let vc = ProfileViewController(presenter: presenter)
        
        presenter.exitButtonDidTap()
        
        XCTAssertTrue(alertPresenter.presentAlertDidCall)
    }
    
    func testPresenterAlertCorrectText() {
        
        final class AlertPresenterSpy: AlertPresenterProtocol {
            var passedAlertModel: AlertModel?
            
            func presentAlert(model: AlertModel, on vc: AnyObject) {
                passedAlertModel = model
            }
        }
        
        let alertPresenter = AlertPresenterSpy()
        let presenter = ProfileViewPresenter(alertPresenter: alertPresenter)
        let vc = ProfileViewController(presenter: presenter)
                
        let expectedAlertModel = AlertModel(title: "Пока, пока!", message: "Уверены что хотите выйти?", buttons: [
            AlertModel.Button(buttonText: "Да", actionHandler: { _ in }, style: .destructive),
            AlertModel.Button(buttonText: "Нет", actionHandler: { _ in }, style: .default)
        ])
        
        presenter.exitButtonDidTap()
        let passedAlertModel = alertPresenter.passedAlertModel!
        
        XCTAssertEqual(passedAlertModel.title, expectedAlertModel.title)
        XCTAssertEqual(passedAlertModel.message, expectedAlertModel.message)
        XCTAssertEqual(passedAlertModel.buttons.first!.buttonText, expectedAlertModel.buttons.first!.buttonText)

    }

    func testPresenterCallsVCUpdateProfileDetailsAfterViewDidLoad() {
        
        class ProfileServiceMock: ProfileServiceProtocol {
            var profile: Profile? = Profile(username: "", name: "", loginName: "", bio: "")
            
            func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, any Error>) -> Void) {
                
            }
            
            func reset() {
                
            }
        }
        
        let profileservice = ProfileServiceMock()
        let presenter = ProfileViewPresenter(profileService: profileservice)
        let vc = ProfileViewControllerSpy(presenter: presenter)
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(vc.updateProfileDetailsCalled)
    }
    
    func testPresenterCallsVCUpdateProfileImageAfterViewDidLoad() {
        
        class ProfileImageServiceMock: ProfileImageServiceProtocol {            
            var avatarUrl: String? = "https://example.com"
            
            func fetchProfileImageURL(_ token: String, username: String, _ completion: @escaping (Result<String, any Error>) -> Void) { }
            
            func reset() { }
        }
        
        let profileImageService = ProfileImageServiceMock()
        let presenter = ProfileViewPresenter(profileImageService: profileImageService)
        let vc = ProfileViewControllerSpy(presenter: presenter)
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(vc.updateAvatarCalled)
    }
}
