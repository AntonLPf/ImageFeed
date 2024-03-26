//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 03.03.24.
//

import Foundation

protocol ImageListServiceProtocol: AnyObject {
    var photos: [Photo] { get }
    var didChangeNotificationName: Notification.Name { get }
    
    func fetchPhotosNextPage(_ token: String,_ completion: @escaping (Result<[Photo], Error>) -> Void)
    
    func changeLike(token: String, photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void)
    
    func reset()
}

extension ImageListServiceProtocol {
    
    var didChangeNotificationName: Notification.Name {
        Notification.Name(Constants.NCNotification.imagesListServiceDidChange)
    }
    
}

final class ImagesListService: ImageListServiceProtocol {
    
    static let shared = ImagesListService()
    private init() {}
    
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    private var ongoingTask: URLSessionTask?
    private let urlSession = URLSession.shared
        
    func fetchPhotosNextPage(_ token: String,_ completion: @escaping (Result<[Photo], Error>) -> Void) {
        ongoingTask?.cancel()
        
        guard ongoingTask == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        let perPage = Constants.UnsplashApi.numberOfImagesPerPage
        let request = ImageListRequest.getImages(page: nextPage, perPage: perPage)

        guard let request = try? request.createURLRequest(token: token) else {
            preconditionFailure("Invalid token request configuration")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResult):
                    let loadedPhotos = photoResult.map { self.convertToPhoto($0) }
                    self.photos.append(contentsOf: loadedPhotos)
                    self.lastLoadedPage = nextPage
                    self.ongoingTask = nil
                    completion(.success(loadedPhotos))
                    
                    NotificationCenter.default.post(
                        name: self.didChangeNotificationName,
                        object: self,
                        userInfo: [:])
                case .failure(let error):
                    self.ongoingTask = nil
                    ErrorPrinterService.shared.printToConsole(error)
                    completion(.failure(error))
                }
            }
        }
        self.ongoingTask = task
        task.resume()
    }
    
    func changeLike(token: String, photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        let request: RequestProtocol = isLike ?
        AddLikeRequest.setLike(imageId: photoId) :
        RemoveLikeRequest.removeLike(imageId: photoId)
        
        guard let request = try? request.createURLRequest(token: token) else {
            assertionFailure("Invalid token request configuration")
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let likeResult):
                    let loadedPhoto = self.convertToPhoto(likeResult.photo)
                    if let index = self.photos.firstIndex(where: { $0.id == loadedPhoto.id }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: loadedPhoto.isLiked
                        )
                        
                        self.photos[index] = newPhoto
                        completion(.success(newPhoto.isLiked))
                    }
                case .failure(let error):
                    ErrorPrinterService.shared.printToConsole(error)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func reset() {
        ongoingTask = nil
        photos = []
        lastLoadedPage = nil
    }
    
    private lazy var fromStringDateFormatter = ISO8601DateFormatter()
    
    private func convertToPhoto(_ photoResult: PhotoResult) -> Photo {
        var dateString = ""
        if let photoDate = fromStringDateFormatter.date(from: photoResult.createdAt) {
            dateString = toStringDateFormatter.string(from: photoDate)
        }
        
        let photo = Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width,
                         height: photoResult.height),
            createdAt: dateString,
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser)
        return photo
    }
    
    private lazy var toStringDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
}
