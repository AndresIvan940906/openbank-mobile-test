//
//  CharacterCell.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 8/11/21.
//

import UIKit
import Kingfisher
class CharacterCell: UICollectionViewCell {

    static let identifier = String(describing: self)
    
    @IBOutlet weak var characterImg: UIImageView!
    @IBOutlet weak var characterName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCellWith(_ character: Character) {
        setImage(url: character.thumbnail.imageUrl)
        characterName.text = character.name
    }
    
    private func setImage(url: URL?) {
        let processor = DownsamplingImageProcessor(size: characterImg.bounds.size)
        characterImg.kf.indicatorType = .activity
        characterImg.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
