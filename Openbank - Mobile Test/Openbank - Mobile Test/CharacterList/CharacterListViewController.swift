//
//  CharacterListViewController.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 8/11/21.
//

import UIKit
import RxCocoa
import RxSwift
class CharacterListViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    var viewModel = CharacterListViewModel()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        registerNib()
        bindData()
        addRefreshControl()
    }
    
    private func addRefreshControl() {
        self.refreshControl.sendActions(for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
    }
    
    func registerNib() {
        let cellNib = UINib(nibName: "CharacterCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: CharacterCell.identifier)
    }
    
    private func bindData() {
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: self.viewModel.reload)
            .disposed(by: disposeBag)
        
        self.viewModel.characterList.asObservable()
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.indicator.stopAnimating()
            }).catch({ error in
                self.presentError(errorDescription: error.localizedDescription)
                return .error(error)
            })
                        .catchAndReturn(.init())
                        .bind(to: self.collectionView.rx.items(cellIdentifier: CharacterCell.identifier, cellType: CharacterCell.self))
            { row, character, cell in
                cell.configCellWith(character)
            }.disposed(by: self.disposeBag)
        
        collectionView.rx.modelSelected(Character.self)
            .subscribe(onNext: { character in
                self.openDetail(character)
            }).disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .subscribe(onNext: { cellInfo in
                let (_, indexPath) = cellInfo
                let sectionAmount = self.collectionView.numberOfSections
                let rowsAmount = self.collectionView.numberOfItems(inSection: indexPath.section)
                if rowsAmount >= 20 && indexPath.section == sectionAmount - 1 && indexPath.row == rowsAmount - 3 {
                    self.viewModel.addPage()
                    self.viewModel.reload.onNext(())
                }
            }).disposed(by: disposeBag)
        
    }
    
    private func openDetail(_ character: Character?) {
        let storyboard = UIStoryboard(name: "CharacterDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: CharacterDetailViewController.self)) as? CharacterDetailViewController
        vc?.viewModel = .init(character: character)
        if let vc = vc {
            let navController = UINavigationController.init(rootViewController: vc)
            self.present(navController, animated: true)
        }
    }
}
extension CharacterListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(collectionView: collectionView)
    }
    
    func sizeForItem(collectionView: UICollectionView) -> CGSize {
        let numberOfItems: CGFloat = 3
        let width: CGFloat = UIScreen.main.bounds.width
        let sparatorSpace: CGFloat = 60
        let cellWidth = ((width - sparatorSpace) / numberOfItems)
        let cellHeight = cellWidth * 1.53
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
