//
//  ComicCell.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 9/11/21.
//

import UIKit
import Kingfisher
class ComicCell: UICollectionViewCell {
    static let identifier = String(describing: self)
    @IBOutlet weak var comicImg: UIImageView!
    @IBOutlet weak var comicTitleLabel: UILabel!
    @IBOutlet weak var comicDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCellWith(_ comic: Comic) {
        setImage(url: comic.thumbnail.imageUrl)
        comicTitleLabel.text = comic.title
        comicDescriptionLabel.text = comic.resultDescription
    }
    
    
    private func setImage(url: URL?) {
        let processor = DownsamplingImageProcessor(size: comicImg.bounds.size)
        comicImg.kf.indicatorType = .activity
        comicImg.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
