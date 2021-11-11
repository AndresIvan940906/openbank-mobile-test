//___FILEHEADER___

import XCTest
import RxSwift
import RxCocoa
@testable import Openbank___Mobile_Test


class Openbank_Mobile_TestTests: XCTestCase {

    
    var disposeBag = DisposeBag()
    var sut: URLSession!

    override func setUpWithError() throws {
      try super.setUpWithError()
      sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
      sut = nil
      try super.tearDownWithError()
    }
    
    
    func testVAlidfirsCharactersPage() throws {
        var data: [Character]?
        let exp = expectation(description: "Call firs page of characters")
        Api.requestService(endpoint: .getCharacters(offset: 0), model: PaginatedCharacters())
            .subscribe(onNext: { paginatedCharacters in
                data = paginatedCharacters.results
                exp.fulfill()
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5)
    
        XCTAssertNotNil(data)
    }
    
    

    func testValidComic() throws {
        var data: [Comic]?
        let exp = expectation(description: "Call Comic endpoint")
        Api.requestService(endpoint: .getComic(comicId: "21975"), model: ComicResult(results: []))
            .subscribe(onNext: { ComicResult in
                data = ComicResult.results
                exp.fulfill()
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5)
    
        XCTAssertNotNil(data)
    }
    
    func testMovieListParser_Success() {
            // Given
        let dictionary = JsonLoader.dictionary(for: .characterList)

            // When
            let characterList = try? DictionaryDecoder().decode(PaginatedCharacters.self, from: dictionary)
            // Then
        let listIsEmpty = characterList?.results.count ?? 0 > 0
        let containsValidIds = characterList?.results.contains(where: { character in
                return character.id != 0
            }) ?? false
        
            XCTAssertEqual(listIsEmpty, false)
            XCTAssertEqual(containsValidIds, false)
        }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
