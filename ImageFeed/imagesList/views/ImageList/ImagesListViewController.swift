//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 02.01.24.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    
    func updateTableViewAnimated(photoIndexes: Range<Int>)
    func showBlockingLoader()
    func hideBlockingLoader()
    
    init(presenter: ImageListPresenterProtocol?)
}

class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    var presenter: ImageListPresenterProtocol?
        
    @IBOutlet private var tableView: UITableView!
    
    required init(presenter: ImageListPresenterProtocol? = nil) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter?.viewDidLoad()
    }
        
    func updateTableViewAnimated(photoIndexes: Range<Int>) {
        tableView.performBatchUpdates {
            let indexPaths = photoIndexes.map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func showBlockingLoader() {
        UIBlockingProgressHUD.show()
    }
    
    func hideBlockingLoader() {
        UIBlockingProgressHUD.dismiss()
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.cellImage.kf.indicatorType = .activity
        let photoIndex = indexPath.row
        
        guard
            let presenter,
            presenter.photos.count > photoIndex
        else { return }
        
        let photo = presenter.photos[photoIndex]
        let imageUrlString = photo.thumbImageURL
        let imageUrl = URL(string: imageUrlString)
        cell.delegate = self
        cell.cellImage.kf.setImage(with: imageUrl) { _ in
            cell.cellImage.contentMode = .scaleAspectFill
            cell.dateLabel.text = photo.createdAt
            cell.setIsLiked(to: photo.isLiked)
            cell.likeButton.isHidden = false
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photos.count ?? 0
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
        guard let presenter else { return }
        
        let vc = SingleImageViewController()
        vc.modalPresentationStyle = .fullScreen
        let url = URL(string: presenter.photos[indexPath.row].largeImageURL)
        vc.imageUrl = url
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard 
            let presenter,
            presenter.photos.count > indexPath.row
        else { return 0 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = presenter.photos[indexPath.row].size.width
        let imageHeight = presenter.photos[indexPath.row].size.height
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let presenter,
            indexPath.row + 1 == presenter.photos.count
        else { return }
        presenter.fetchMorePhotos()
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard 
            let presenter,
            let indexPath = tableView.indexPath(for: cell)
        else {
            assertionFailure("Could not configure CellDidTapLike method")
            return
        }
        
        let photo = presenter.photos[indexPath.row]
        let setLikeTo = !photo.isLiked
        UIBlockingProgressHUD.show()
        presenter.changeLike(photoId: photo.id, isLike: setLikeTo) { result in
            switch result {
            case .success:
                cell.setIsLiked(to: presenter.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let failure):
                UIBlockingProgressHUD.dismiss()
                ErrorPrinterService.shared.printToConsole(failure)
            }
        }
    }
}
