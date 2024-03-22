//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 20.03.24.
//

import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func exitButtonDidTap()
    func viewDidLoad()
}

class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private var windowController: WindowControllerProtocol?
    private var profileService: ProfileServiceProtocol?
    private var profileLogoutService: ProfileLogoutServiceProtocol?
    private var profileImageService: ProfileImageServiceProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?

    init(windowController: WindowControllerProtocol = WindowController(),
         profileService: ProfileServiceProtocol = ProfileService.shared,
         profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
         alertPresenter: AlertPresenterProtocol = AlertPresenter()) {
        self.windowController = windowController
        self.profileService = profileService
        self.profileLogoutService = profileLogoutService
        self.profileImageService = profileImageService
        self.alertPresenter = alertPresenter
        
        self.profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: profileImageService.didChangeNotificationName,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.updateProfileImage()
            })
    }
        
    func exitButtonDidTap() {
        guard let view else { return }
        let alertModel = getLogoutAlertModel()
        alertPresenter?.presentAlert(model: alertModel, on: view)
    }
    
    func viewDidLoad() {
        guard view != nil else { preconditionFailure("ProfileViewPresenter's view is nil") }
        updateProfileDetails()
        updateProfileImage()
    }
    
    // MARK: - Private methods
    
    private func updateProfileDetails() {
        if let profile = profileService?.profile {
            view?.updateProfileDetails(with: profile)
        }
    }
    
    private func getLogoutAlertModel() -> AlertModel {
        let alertModel = AlertModel(title: "Пока, пока!", message: "Уверены что хотите выйти?", buttons: [
            AlertModel.Button(buttonText: "Да", actionHandler: { _ in
                guard let profileLogoutService = self.profileLogoutService else {
                    preconditionFailure("Logout servise has not setup")
                }
                profileLogoutService.logout()
                self.gotoSplashScreen()
            }, style: .destructive),
            AlertModel.Button(buttonText: "Нет", actionHandler: { _ in }, style: .default)
        ])
        return alertModel
    }
    
    private func updateProfileImage() {
        guard
            let profileImageService,
            let profileImageUrl = profileImageService.avatarUrl,
            let imageUrl = URL(string: profileImageUrl)
        else { return }
        view?.updateAvatar(avatarUrl: imageUrl)
    }
    
    private func gotoSplashScreen() {
        let splashViewController = SplashViewController()
        windowController?.setRootController(to: splashViewController)
    }
}
