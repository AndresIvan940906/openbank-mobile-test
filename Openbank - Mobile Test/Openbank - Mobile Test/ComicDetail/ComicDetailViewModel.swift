//
//  ComicDetailViewModel.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 10/11/21.
//

import Foundation
import RxSwift
import RxCocoa
class ComicDetailViewModel {
    let comicImageUrl: URL?
    let comicTitle = BehaviorRelay<String?>(value: "")
    let comicDescription = BehaviorRelay<String?>(value: "")
    let comicCharacters = BehaviorRelay<String?>(value: "")
    let comicCreators = BehaviorRelay<String?>(value: "")
    var disposeBag = DisposeBag()
    init(comic: Comic?) {
        comicTitle.accept(comic?.title)
        comicDescription.accept(comic?.resultDescription)
        comicImageUrl = comic?.thumbnail.imageUrl
        var allCharacters =  ""
        var allCreators =  ""
        comic?.characters.items.forEach({ character in
            allCharacters.append("\(character.name), ")
        })
        allCharacters.removeLast(2)
        
        comic?.creators.items.forEach({ creator in
            allCreators.append("\(creator.name) (\(creator.role)), ")
        })
        allCreators.removeLast(2)
        comicCharacters.accept(allCharacters)
        comicCreators.accept(allCreators)
        
        
    }
}
