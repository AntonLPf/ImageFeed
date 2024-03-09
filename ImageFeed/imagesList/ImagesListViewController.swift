//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 02.01.24.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private let oauthService = OAuth2Service.shared
    
    @IBOutlet private var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        self.fetchMorePhotos()
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.cellImage.kf.indicatorType = .activity
        let photoIndex = indexPath.row
        
        guard imagesListService.photos.count > photoIndex else { return }
        
        let placeHolderImage = UIImage(named: Constants.Picture.profilePicturePlaceHolder)
        let photo = imagesListService.photos[photoIndex]
        let imageUrlString = photo.thumbImageURL
        let imageUrl = URL(string: imageUrlString)
        cell.cellImage.kf.setImage(with: imageUrl, placeholder: placeHolderImage, options: nil) { _ in
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            if let date = photo.createdAt {
                cell.dateLabel.text = self.dateFormatter.string(from: date)
            }
            
            let likeImageName = photo.isLiked ? "LikePressed" : "LikeUnPressed"
            cell.likeButton.imageView?.image = UIImage(named: likeImageName)
            cell.likeButton.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard 
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else { return }
//            let image = UIImage(named: photosName[indexPath.row])
//            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
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
            case .success(let images):
                debugPrint("Loaded photos number: \(images.count)")
                debugPrint(self.imagesListService.photos.count)
                self.tableView.reloadData()
            case .failure(let failure):
                debugPrint("Failed to load more photos")
                ErrorPrinterService.shared.printToConsole(failure)
            }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imagesListService.photos.count
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
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard imagesListService.photos.count > indexPath.row else { return 0 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imagesListService.photos[indexPath.row].size.width
        let imageHeight = imagesListService.photos[indexPath.row].size.height
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard indexPath.row + 1 == photos.count else { return }
    }
    
}
