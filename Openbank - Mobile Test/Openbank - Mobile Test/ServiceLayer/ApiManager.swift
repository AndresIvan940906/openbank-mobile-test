//
//  ApiManager.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 8/11/21.
//

import Foundation
import Moya
import RxSwift
import Alamofire
import RxMoya

private let defaultManager: Session = {
    
    let manager = ServerTrustManager(allHostsMustBeEvaluated: false,
                                     evaluators: ["190.131.203.107": DisabledTrustEvaluator()])
    let configuration = URLSessionConfiguration.af.default
    configuration.waitsForConnectivity = true
    
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    
    let responseCacher = ResponseCacher(behavior: .modify { _, response in
      let userInfo = ["date": Date()]
      return CachedURLResponse(
        response: response.response,
        data: response.data,
        userInfo: userInfo,
        storagePolicy: .allowed)
    })
    
    return Session(configuration: configuration, serverTrustManager: manager, cachedResponseHandler: responseCacher)
}()

let ApiProvider  = MoyaProvider<Api>(session: defaultManager)
var disposeBag = DisposeBag()

enum Api {
    case getCharacters(offset: Int)
    case getComic(comicId: String)
}


extension Api: TargetType {
    
    var baseURL: URL {
        return URL(string: APIBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .getCharacters:
            return "characters"
        case .getComic(let comicId):
            return "comics/\(comicId)"
        }
    }
    
    var method: Moya.Method  {
        switch self {
        case .getCharacters, .getComic:
            return .get
        }
        
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        let ts = "\(Date.timeIntervalSinceReferenceDate)"
        switch self {
        case .getCharacters(let offset):
            return .requestParameters(parameters: [
                "limit": limit,
                "apikey":apiKey,
                "offset": "\(offset)",
                "ts": ts,
                "hash": (ts + privateKey + apiKey).md5
                
            ], encoding: URLEncoding.queryString)
        case .getComic:
            return .requestParameters(parameters: [
                "apikey": apiKey,
                "ts": ts,
                "hash": (ts + privateKey + apiKey).md5
                
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
    static func requestService<T: Codable>(endpoint: Api, model: T) -> Observable<T> {
        
        return Observable<T>.create { (observer) -> Disposable in
        
            ApiProvider.rx.request(endpoint).subscribe { event in
                
                switch event {
                    
                case let .success(response):
                    
                    switch response.statusCode{
                    case 200...299:
                        if let model = try? response.map(T.self, atKeyPath: "data", using: JSONDecoder.init(), failsOnEmptyData: false) {
                            observer.onNext(model)
                            observer.onCompleted()
                        } else if  let simpleModel = try? response.map(T.self) {
                            observer.onNext(simpleModel)
                            observer.onCompleted()
                        } else {
                            
                            print("JSONDecoder Model error")
                        }
                        
                    default:
                        let errorMap : ErrorModel? = try? response.map(ErrorModel.self)
                        let message = errorMap?.message?.isEmpty ?? true ? errorMap?.status : errorMap?.message
                        
                        let error = NSError(domain: message ?? "Server Error", code: response.statusCode, userInfo: nil)
                        
                        observer.onError(error)
                        observer.onCompleted()
    
                        break
                    }
                    
                case let .failure(error):
                    observer.onError(error)
                    observer.onCompleted()
                }
            }.disposed(by: disposeBag)
            
            return Disposables.create {
                
            }
        }
        
    }
    
}
