//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 22.03.24.
//

import Foundation

protocol ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func fetchMorePhotos()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

class ImageListPresenter: ImageListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    private var imagesListService: ImageListServiceProtocol?
    private var oauthService: OAuth2ServiceProtocol?
    
    private var imageListServiceObserver: NSObjectProtocol?
    
    var photos: [Photo] = []
    
    init(imagesListService: ImageListServiceProtocol = ImagesListService.shared,
         oauthService: OAuth2ServiceProtocol = OAuth2Service.shared) {
        self.imagesListService = imagesListService
        self.oauthService = oauthService
        
        self.imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: imagesListService.didChangeNotificationName,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                
                let oldCount = photos.count
                let newCount = imagesListService.photos.count
                if oldCount != newCount {
                    photos = imagesListService.photos
                    let photoIndexes = (oldCount..<newCount)
                    self.view?.updateTableViewAnimated(photoIndexes: photoIndexes)
                }
            })
    }
    
    func viewDidLoad() {
        view?.showBlockingLoader()
        fetchMorePhotos()
    }
    
    func fetchMorePhotos() {
        guard let token = oauthService?.token else { return }
        
        imagesListService?.fetchPhotosNextPage(token) { result in
            switch result {
            case .success(let photos):
                debugPrint("Loaded photos number: \(photos.count)")
                self.view?.hideBlockingLoader()
            case .failure(let failure):
                ErrorPrinterService.shared.printToConsole(failure)
                self.view?.hideBlockingLoader()
            }
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard
            let token = oauthService?.token,
            let imagesListService
        else { return }

        imagesListService.changeLike(token: token, photoId: photoId, isLike: isLike) { result in
            switch result {
            case .success:
                self.photos = imagesListService.photos
                completion(.success(()))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
