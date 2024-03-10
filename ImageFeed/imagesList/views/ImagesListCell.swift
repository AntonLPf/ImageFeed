//
//  ImagesListCellTableViewCell.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 03.01.24.
//

import UIKit
import Kingfisher

class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    var photo: Photo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func likeButtonTapped() {
        guard let photo else { return }
        
        let oauthService = OAuth2Service.shared
        guard let token = oauthService.token else { return }
        let imageListService = ImagesListService.shared
        
        let setLikeTo = !photo.isLiked
        
        imageListService.changeLike(token: token, photoId: photo.id, isLike: setLikeTo) { result in
            
            switch result {
            case .success(let success):
                
                
            case .failure(let failure):
                
            }
            
        }
    }
    
    private func resetCell() {
        likeButton.isHidden = true
        dateLabel.text = ""
    }
}
