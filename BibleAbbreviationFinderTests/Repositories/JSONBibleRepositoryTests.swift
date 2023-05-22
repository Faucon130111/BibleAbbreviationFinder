//
//  JSONBibleRepositoryTests.swift
//  BibleAbbreviationFinderTests
//
//  Created by faucon130111 on 2023/05/03.
//

import Foundation
import Combine
import Quick
import Nimble
@testable import BibleAbbreviationFinder

final class JSONBibleRepositoryTests: QuickSpec {
    override func spec() {
        describe("JSONBibleRepository") {
            context("json 파일을 Data 변환에 실패한 경우") {
                it("Errors.invalidData 에러가 발생한다.") {
                    let jsonData: Data? = nil
                    let repository = JSONBibleRepository(for: jsonData)
                    
                    var occurredError: Error?
                    var bibles: [Bible] = []
                    
                    _ = repository.loadBibles()
                        .sink(receiveCompletion: {
                            if case let .failure(error) = $0 {
                                occurredError = error
                            }
                        }) { bibles = $0 }
                    
                    expect(bibles).to(beEmpty())
                    expect(occurredError).to(matchError(Errors.invalidData))
                }
            }
            
            context("비정상적인 json 파일을 불러온 경우") {
                it("Errors.decodeFailed 에러가 발생한다.") {
                    let jsonString = " [{ wrong json data }] "
                    let jsonData = jsonString.data(using: .utf8)
                    let repository = JSONBibleRepository(for: jsonData)
                    
                    var occurredError: Error?
                    var bibles: [Bible] = []
                    
                    _ = repository.loadBibles()
                        .sink(receiveCompletion: {
                            if case let .failure(error) = $0 {
                                occurredError = error
                            }
                        }) { bibles = $0 }
                    
                    expect(bibles).to(beEmpty())
                    expect(occurredError).to(matchError(Errors.decodeFailed("")))
                }
            }
            
            context("정상적인 json 파일을 불러와서") {
                it("Bible Array 데이터 변환을 성공한다.") {
                    let jsonString = """
                    [
                        { "name": "창세기", "abbreviation": "창" },
                        { "name": "출애굽기", "abbreviation": "출" },
                        { "name": "레위기", "abbreviation": "레" }
                    ]
                    """
                    let jsonData = jsonString.data(using: .utf8)
                    let repository = JSONBibleRepository(for: jsonData)
                    
                    var bibles: [Bible] = []
                    var success: Bool = false
                    
                    _ = repository.loadBibles()
                        .sink(receiveCompletion: {
                            if case let .failure(error) = $0 {
                                fail("receive bibles failure for json: \(error)")
                            } else {
                                success = true
                            }
                        }) { bibles = $0 }
                    
                    let expectedBibles: [Bible] = [
                        Bible(name: "창세기", abbreviation: "창"),
                        Bible(name: "출애굽기", abbreviation: "출"),
                        Bible(name: "레위기", abbreviation: "레")
                    ]
                    
                    expect(success).to(beTrue())
                    expect(bibles).to(equal(expectedBibles))
                }
            }
        }
    }
}
