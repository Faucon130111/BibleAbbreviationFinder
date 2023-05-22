//
//  ScriptureFinderTests.swift
//  BibleAbbreviationFinderTests
//
//  Created by faucon130111 on 2023/05/04.
//

import Foundation
import Combine
import Quick
import Nimble
@testable import BibleAbbreviationFinder

final class ScriptureFinderTests: QuickSpec {
    override func spec() {
        describe("ScriptureFinder") {
            let finder = ScriptureFinder()
            var scripture: Scripture?
            
            context("검색어가 비어있는 경우") {
                it("데이터 추출을 하지 않는다.") {
                    let searchText = ""
                    let expectedScripture = Scripture(
                        chapter: nil,
                        verses: nil
                    )
                    
                    _ = finder
                        .analyze(for: searchText)
                        .sink {
                            scripture = $0
                        }
                    
                    expect(scripture).to(equal(expectedScripture))
                }
            }
            context("검색어에 name만 들어간 경우") {
                it("name만 추출한다.") {
                    let searchText = "창세기"
                    let expectedScripture = Scripture(
                        name: "창세기",
                        chapter: nil,
                        verses: nil
                    )
                    
                    _ = finder
                        .analyze(for: searchText)
                        .sink {
                            scripture = $0
                        }
                    
                    expect(scripture).to(equal(expectedScripture))
                }
            }
            context("검색어가 name + chapter인 경우") {
                it("name과 chapter만 추출한다.") {
                    let searchText = "창세기 11"
                    let expectedScripture = Scripture(
                        name: "창세기",
                        chapter: 11,
                        verses: nil
                    )
                    
                    _ = finder
                        .analyze(for: searchText)
                        .sink {
                            scripture = $0
                        }
                    
                    expect(scripture).to(equal(expectedScripture))
                }
            }
            context("검색어가 name + chapter + :인 경우") {
                it("name과 chapter만 추출한다.") {
                    let searchText = "창세기 11:"
                    let expectedScripture = Scripture(
                        name: "창세기",
                        chapter: 11,
                        verses: nil
                    )
                    
                    _ = finder
                        .analyze(for: searchText)
                        .sink {
                            scripture = $0
                        }
                    
                    expect(scripture).to(equal(expectedScripture))
                }
            }
            context("검색어가 name + chapter + verse인 경우") {
                it("해당 데이터를 정상적으로 추출한다.") {
                    let searchText = "창세기 11:20"
                    let expectedScripture = Scripture(
                        name: "창세기",
                        chapter: 11,
                        verses: [20]
                    )
                    
                    _ = finder
                        .analyze(for: searchText)
                        .sink {
                            scripture = $0
                        }
                    
                    expect(scripture).to(equal(expectedScripture))
                }
            }
            context("검색어가 name + chapter + verse + -인 경우") {
                it("해당 데이터를 정상적으로 추출한다.") {
                    let searchText = "창세기 11:20-"
                    let expectedScripture = Scripture(
                        name: "창세기",
                        chapter: 11,
                        verses: [20]
                    )
                    
                    _ = finder
                        .analyze(for: searchText)
                        .sink {
                            scripture = $0
                        }
                    
                    expect(scripture).to(equal(expectedScripture))
                }
            }
            context("검색어가 name + chapter + verse 범위인 경우") {
                it("해당 데이터를 정상적으로 추출한다.") {
                    let searchText = "창세기 11:20-25"
                    let expectedScripture = Scripture(
                        name: "창세기",
                        chapter: 11,
                        verses: [
                            20,
                            21,
                            22,
                            23,
                            24,
                            25
                        ]
                    )
                    
                    _ = finder
                        .analyze(for: searchText)
                        .sink {
                            scripture = $0
                        }
                    
                    expect(scripture).to(equal(expectedScripture))
                }
            }
            context("검색어에 verse 범위가 같게 들어간 경우") {
                it("verse 데이터는 추출하지 않는다.") {
                    let searchText = "창세기 11:20-20"
                    let expectedScripture = Scripture(
                        name: "창세기",
                        chapter: 11,
                        verses: nil
                    )
                    
                    _ = finder
                        .analyze(for: searchText)
                        .sink {
                            scripture = $0
                        }
                    
                    expect(scripture).to(equal(expectedScripture))
                }
            }
            context("검색어에 verse 범위가 반대로 들어간 경우") {
                it("verse 데이터는 추출하지 않는다.") {
                    let searchText = "창세기 11:25-20"
                    let expectedScripture = Scripture(
                        name: "창세기",
                        chapter: 11,
                        verses: nil
                    )
                    
                    _ = finder
                        .analyze(for: searchText)
                        .sink {
                            scripture = $0
                        }
                    
                    expect(scripture).to(equal(expectedScripture))
                }
            }
            context("검색어에 verse가 나열된 경우") {
                it("해당 번호를 연속하여 추출한다.") {
                    let searchText = "창세기 11:20, 21,25, 28"
                    let expectedScripture = Scripture(
                        name: "창세기",
                        chapter: 11,
                        verses: [
                            20,
                            21,
                            25,
                            28
                        ]
                    )
                    
                    _ = finder
                        .analyze(for: searchText)
                        .sink {
                            scripture = $0
                        }
                    
                    expect(scripture).to(equal(expectedScripture))
                }
            }
        }
    }
}
