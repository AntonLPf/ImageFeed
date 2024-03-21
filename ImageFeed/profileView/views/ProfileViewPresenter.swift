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

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private var windowController: WindowControllerProtocol?
    private var profileService: ProfileServiceProtocol?
    private var profileLogoutService: ProfileLogoutServiceProtocol?
    private var profileImageService: ProfileImageServiceProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared,
         profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
         alertPresenter: AlertPresenterProtocol = AlertPresenter(),
         windowController: WindowControllerProtocol = WindowController()) {
        self.profileService = profileService
        self.profileLogoutService = profileLogoutService
        self.profileImageService = profileImageService
        self.configureProfileImageServiceObserver()
        self.alertPresenter = alertPresenter
        self.windowController = windowController
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
            let profileImageUrl = ProfileImageService.shared.avatarUrl,
            let imageUrl = URL(string: profileImageUrl)
        else { return }
        view?.updateAvatar(avatarUrl: imageUrl)
    }
    
    private func gotoSplashScreen() {
        let splashViewController = SplashViewController()
        windowController?.setRootController(to: splashViewController)
    }
    
    private func configureProfileImageServiceObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.updateProfileImage()
            })
    }
}
