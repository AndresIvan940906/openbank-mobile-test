//
//  CharacterListViewModel.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 8/11/21.
//

import Foundation
import RxSwift

class CharacterListViewModel {
    var reload: AnyObserver<Void>!
    var offset: AnyObserver<Int>!
    var characterList: Observable<[Character]> = Observable.just([])
    var currentCharacters: [Character] = []
    var disposeBag = DisposeBag()
    var currenOffset = 0
    init(offset: Int = 0){
        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()
        
        let _offSet = BehaviorSubject<Int>(value: offset)
        self.offset = _offSet.asObserver()
        
        characterList = Observable.combineLatest(_reload,_offSet){ _, offSet in (offSet) }
        .observe(on: SerialDispatchQueueScheduler(qos: .background))
        .flatMapLatest({ offset -> Observable<PaginatedCharacters> in
            return  Api.requestService(endpoint: .getCharacters(offset: offset), model: PaginatedCharacters())
        })
        
        .catch({ (error) -> Observable<PaginatedCharacters> in
            return .error(error)
        })
                .map({ item in
                    self.currentCharacters.append(contentsOf: item.results)
                    return self.currentCharacters
                })
                
    }
    
    func addPage() {
        currenOffset += 20
        offset.onNext(currenOffset)
    }
}
