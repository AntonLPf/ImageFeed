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
    
    private func resetCell() {
        likeButton.isHidden = true
        dateLabel.text = ""
    }
}
