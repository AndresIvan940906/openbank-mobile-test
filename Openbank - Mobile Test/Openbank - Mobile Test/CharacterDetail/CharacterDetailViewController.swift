//
//  CharacterDetailViewController.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 9/11/21.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var characterImg: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var viewModel: CharacterDetailViewModel!
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        bindData()
        setImage()
        registerNib()
    }
    
    func registerNib() {
        let cellNib = UINib(nibName: "ComicCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: ComicCell.identifier)
    }
    
    private func bindData() {
        
        closeButton?.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.characterName.bind(to: self.characterNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.characterDescription.bind(to: self.characterDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        viewModel.comics.asObservable()
            .do(onNext: { [weak self] _ in
                self?.indicator.stopAnimating()
            })
            .bind(to: self.collectionView.rx.items(cellIdentifier: ComicCell.identifier, cellType: ComicCell.self))
            { row, comic, cell in
                cell.configCellWith(comic)
            }.disposed(by: self.disposeBag)
        
        collectionView.rx.modelSelected(Comic.self)
            .subscribe(onNext: { comic in
                self.openDetail(comic)
            }).disposed(by: self.disposeBag)
    }
    
    private func setImage() {
        
        let url = viewModel.characterImageUrl
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
    
    private func openDetail(_ comic: Comic?) {
        let storyboard = UIStoryboard(name: "ComicDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: ComicDetailViewController.self)) as? ComicDetailViewController
        vc?.viewModel = .init(comic: comic)
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension CharacterDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(collectionView: collectionView)
    }
    
    func sizeForItem(collectionView: UICollectionView) -> CGSize {
        let numberOfItems: CGFloat = 3
        let width: CGFloat = UIScreen.main.bounds.width
        let sparatorSpace: CGFloat = 60
        let cellWidth = ((width - sparatorSpace) / numberOfItems)
        let cellHeight = cellWidth * 1.63
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
