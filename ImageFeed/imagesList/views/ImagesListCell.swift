//
//  ImagesListCellTableViewCell.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 03.01.24.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
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
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(to state: Bool) {
        let likeImageName = state ? "LikePressed" : "LikeUnPressed"
        likeButton.imageView?.image = UIImage(named: likeImageName)
    }
    
    private func resetCell() {
        likeButton.isHidden = true
        dateLabel.text = ""
    }
}
