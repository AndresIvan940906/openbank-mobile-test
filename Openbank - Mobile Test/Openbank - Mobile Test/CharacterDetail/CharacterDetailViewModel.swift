//
//  CharacterDetailViewModel.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 9/11/21.
//

import Foundation
import RxSwift
import RxCocoa
class CharacterDetailViewModel {
    var characterImageUrl: URL?
    var characterName = BehaviorRelay<String>(value: "")
    var characterDescription = BehaviorRelay<String>(value: "")
    var comicRequests: [Single<ComicResult>] = []
    var comics = PublishSubject<[Comic]>()
    var disposeBag = DisposeBag()
    init(character: Character?) {
        self.characterImageUrl = character?.thumbnail.imageUrl
        self.characterName.accept(character?.name ?? "")
        self.characterDescription.accept(character?.resultDescription ?? "")
        let comicIDs = character?.comics.items.map({ item -> String? in
            let comicID = URL.init(string: item.resourceURI)?.lastPathComponent
            return comicID
        }).compactMap{ $0 } ?? []
        
        comicIDs.forEach { id in
            let request = self.getComic(comicId: id)
            comicRequests.append(request)
        }
        
        let comics = comicRequests.map{$0.map({$0.results})}
   
        let finalSequence = Single.zip(comics)
    
        finalSequence.subscribe { result in
            let mappedComics = result.map { comics in
                return comics.first ?? .init()
            }
            self.comics.onNext(mappedComics)
        } onFailure: { error in } onDisposed: {}
        .disposed(by: self.disposeBag)
    }
    
    private func getComic(comicId: String) -> Single<ComicResult> {
        Single<ComicResult>.create { (observer) -> Disposable in
            Api.requestService(endpoint: .getComic(comicId: comicId), model: ComicResult(results: []))
                .subscribe(onNext: { comic in
                    observer(Result.success(comic))
                }).disposed(by: self.disposeBag)
            return Disposables.create {
                
            }
        }
    }
}
