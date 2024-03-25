//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 25.02.24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor(named: Constants.Color.ypWhite)
        tabBar.unselectedItemTintColor = UIColor(named: Constants.Color.ypGray)
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor(named: Constants.Color.ypBlack)
        tabBar.backgroundColor = UIColor(named: Constants.Color.ypBlack)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        if let vc = imagesListViewController as? ImagesListViewControllerProtocol {
            let imageListPresenter = ImageListPresenter()
            imageListPresenter.view = vc
            vc.presenter = imageListPresenter
        }
        let profileViewPresenter = ProfileViewPresenter()
        let profileViewController = ProfileViewController(presenter: profileViewPresenter)
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        viewControllers = [imagesListViewController, profileViewController]
    }

}
