//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 03.03.24.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(
        Constants.NCNotification.imagesListServiceDidChange
    )
    
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    private var ongoingTask: URLSessionTask?
    private let urlSession = URLSession.shared
        
    func fetchPhotosNextPage(_ token: String,_ completion: @escaping (Result<[Photo], Error>) -> Void) {
        ongoingTask?.cancel()
        let nextPage = (lastLoadedPage ?? 0) + 1
        let perPage = Constants.SplashApi.numberOfImagesPerPage
        let request = ImageListRequest.getImages(page: nextPage, perPage: perPage)

        guard let request = try? request.createURLRequest(token: token) else {
            preconditionFailure("Invalid token request configuration")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResult):
                let loadedPhotos = convertToPhotos(photoResult)
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: loadedPhotos)
                    self.lastLoadedPage = nextPage
                    completion(.success(loadedPhotos))
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: [:])
                }
            case .failure(let error):
                ErrorPrinterService.shared.printToConsole(error)
                completion(.failure(error))
            }
        }
        self.ongoingTask = task
        task.resume()
        
    }
    
    private func convertToPhotos(_ photoResult: [PhotoResult]) -> [Photo] {
        photoResult.map { photoResult in
            Photo(id: photoResult.id,
                  size: CGSize(width: photoResult.width,
                               height: photoResult.height),
                  createdAt: ISO8601DateFormatter().date(from: photoResult.createdAt),
                  welcomeDescription: photoResult.description,
                  thumbImageURL: photoResult.urls.thumb,
                  largeImageURL: photoResult.urls.full,
                  isLiked: photoResult.likedByUser)
        }
    }
}
