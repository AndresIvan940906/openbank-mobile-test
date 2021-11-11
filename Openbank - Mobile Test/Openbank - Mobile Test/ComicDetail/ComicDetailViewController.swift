//
//  ComicDetailViewController.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 10/11/21.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
class ComicDetailViewController: UIViewController {
    
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicDescriptionLabel: UILabel!
    @IBOutlet weak var comicCharactersLabel: UILabel!
    @IBOutlet weak var comicCreatorsLabel: UILabel!
    @IBOutlet weak var comicImg: UIImageView!
    var viewModel: ComicDetailViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        self.setImage()
    }
    
    private func bindData() {
        viewModel.comicTitle.bind(to: self.comicTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.comicDescription.bind(to: self.comicDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.comicCharacters.bind(to: self.comicCharactersLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.comicCreators.bind(to: self.comicCreatorsLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setImage() {
        let url = viewModel.comicImageUrl
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
