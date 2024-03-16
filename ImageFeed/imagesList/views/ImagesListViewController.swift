//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 02.01.24.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    private let imagesListService = ImagesListService.shared
    private let oauthService = OAuth2Service.shared
    
    private var imageListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    private var photos: [Photo] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            })
        
        self.fetchMorePhotos()
    }
    
    private lazy var placeHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = .placeHolderGray

        let placeHolderImage = UIImage(named: Constants.Picture.imagePlaceHolder)
        let imageView = UIImageView(image: placeHolderImage)
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.cellImage.kf.indicatorType = .activity
        let photoIndex = indexPath.row
        
        guard photos.count > photoIndex else { return }
        
        let photo = photos[photoIndex]
        let imageUrlString = photo.thumbImageURL
        let imageUrl = URL(string: imageUrlString)
        cell.delegate = self
        cell.cellImage.kf.setImage(with: imageUrl, placeholder: placeHolderView, options: nil) { _ in
            cell.cellImage.contentMode = .scaleAspectFill
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            if let date = photo.createdAt {
                cell.dateLabel.text = self.dateFormatter.string(from: date)
            } else {
                cell.dateLabel.text = ""
            }
            cell.setIsLiked(to: photo.isLiked)
            cell.likeButton.isHidden = false
        }
    }
        
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private func fetchMorePhotos() {
        guard let token = oauthService.token else { return }
                
        imagesListService.fetchPhotosNextPage(token) { result in
            switch result {
            case .success(let photos):
                debugPrint("Loaded photos number: \(photos.count)")
            case .failure(let failure):
                ErrorPrinterService.shared.printToConsole(failure)
            }
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = SingleImageViewController()
        vc.modalPresentationStyle = .fullScreen
        let url = URL(string: self.photos[indexPath.row].largeImageURL)
        vc.imageUrl = url
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard photos.count > indexPath.row else { return 0 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let imageHeight = photos[indexPath.row].size.height
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == photos.count else { return }
        fetchMorePhotos()
    }
    
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard 
            let indexPath = tableView.indexPath(for: cell),
            let token = oauthService.token
        else {
            assertionFailure("Could not configure CellDidTapLike method")
            return
        }
        
        let photo = photos[indexPath.row]
        let setLikeTo = !photo.isLiked
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(token: token, photoId: photo.id, isLike: setLikeTo) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(to: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let failure):
                UIBlockingProgressHUD.dismiss()
                ErrorPrinterService.shared.printToConsole(failure)
            }
        }
    }
}

extension UIView: Placeholder {}
