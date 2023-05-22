//
//  SearchViewInteractorTests.swift
//  BibleAbbreviationFinderTests
//
//  Created by faucon130111 on 2023/05/22.
//

import Combine
import Quick
import Nimble
@testable import BibleAbbreviationFinder

final class SearchViewInteractorTests: QuickSpec {
    override func spec() {
        describe("SearchViewInteractor") {
            context("검색어를 분석하면") {
                it("Scripture, abbreviationText를 업데이트 한다.") {
                    let scriptureFinder = ScriptureFinder()
                    let appState = AppState(status: .loadedBibles)
                    let interactor = SearchViewInteractor(scriptureFinder: scriptureFinder)
                    let searchText = "요한 3:16"
                    
                    interactor
                        .perform(
                            action: .analyze(searchText),
                            in: appState
                        )
                    
                    let expectedScripture = Scripture(
                        name: "요한",
                        bible: nil,
                        chapter: 3,
                        verses: [16]
                    )
                    
                    expect(appState.scripture).to(equal(expectedScripture))
                    expect(appState.abbreviationText).to(beEmpty())
                }
            }
            
            context("검색어를 모두 지우면") {
                it("비어있는 Scripture를 업데이트 한다.") {
                    let scriptureFinder = ScriptureFinder()
                    let appState = AppState(status: .loadedBibles)
                    let interactor = SearchViewInteractor(scriptureFinder: scriptureFinder)
                    let searchText = ""
                    
                    interactor
                        .perform(
                            action: .analyze(searchText),
                            in: appState
                        )
                    
                    let expectedScripture: Scripture = .empty
                    
                    expect(appState.scripture).to(equal(expectedScripture))
                    expect(appState.scripture.bible).to(beNil())
                }
            }
            
            context("성경을 선택하면") {
                it("Scripture.bible을 업데이트 한다.") {
                    let scriptureFinder = ScriptureFinder()
                    let appState = AppState(status: .loadedBibles)
                    let interactor = SearchViewInteractor(scriptureFinder: scriptureFinder)
                    let bible = Bible(
                        name: "요한복음",
                        abbreviation: "요"
                    )
                    
                    interactor
                        .perform(
                            action: .select(bible),
                            in: appState
                        )
                    
                    expect(appState.scripture.bible).to(equal(bible))
                }
            }
        }
        
        describe("SearchViewInteractor.updateAbbreviationText(in:)") {
            let bible = Bible(
                name: "창세기",
                abbreviation: "창"
            )
            
            context("Scripture 모든 값이 없을 경우") {
                it("빈값을 업데이트한다.") {
                    let scripture = Scripture(
                        name: nil,
                        bible: nil,
                        chapter: nil,
                        verses: nil
                    )
                    let scriptureFinder = ScriptureFinderStub(scripture: scripture)
                    let interactor = SearchViewInteractor(scriptureFinder: scriptureFinder)
                    let appState = AppState(
                        status: .loadedBibles,
                        scripture: scripture
                    )
                    
                    interactor.updateAbbreviationText(in: appState)
                    
                    expect(appState.abbreviationText).to(beEmpty())
                }
            }
            
            context("Scripture name만 있는 경우") {
                it("빈값을 업데이트한다.") {
                    let scripture = Scripture(
                        name: "창세",
                        bible: nil,
                        chapter: nil,
                        verses: nil
                    )
                    let scriptureFinder = ScriptureFinderStub(scripture: scripture)
                    let interactor = SearchViewInteractor(scriptureFinder: scriptureFinder)
                    let appState = AppState(
                        status: .loadedBibles,
                        scripture: scripture
                    )
                    
                    interactor.updateAbbreviationText(in: appState)
                    
                    expect(appState.abbreviationText).to(beEmpty())
                }
            }
            
            context("Scripture name, bible이 있는 경우") {
                it("abbreviationText는 해당 성경 약어만 업데이트한다.") {
                    let scripture = Scripture(
                        name: "창세",
                        bible: bible,
                        chapter: nil,
                        verses: nil
                    )
                    let scriptureFinder = ScriptureFinderStub(scripture: scripture)
                    let interactor = SearchViewInteractor(scriptureFinder: scriptureFinder)
                    let appState = AppState(
                        status: .loadedBibles,
                        scripture: scripture
                    )
                    
                    interactor.updateAbbreviationText(in: appState)
                    
                    let expectText = "창"
                    expect(appState.abbreviationText).to(equal(expectText))
                }
            }
            
            context("Scripture name, bible, chapter가 있는 경우") {
                it("abbreviationText는 약어 + chapter를 업데이트한다.") {
                    let scripture = Scripture(
                        name: "창세",
                        bible: bible,
                        chapter: 1,
                        verses: nil
                    )
                    let scriptureFinder = ScriptureFinderStub(scripture: scripture)
                    let interactor = SearchViewInteractor(scriptureFinder: scriptureFinder)
                    let appState = AppState(
                        status: .loadedBibles,
                        scripture: scripture
                    )
                    
                    interactor.updateAbbreviationText(in: appState)
                    
                    let expectText = "창 1"
                    expect(appState.abbreviationText).to(equal(expectText))
                }
            }
            
            context("Scripture name, bible, chapter, verses가 한 개 있는 경우") {
                it("abbreviationText는 약어 + chapter + verse를 업데이트한다.") {
                    let scripture = Scripture(
                        name: "창세",
                        bible: bible,
                        chapter: 1,
                        verses: [1]
                    )
                    let scriptureFinder = ScriptureFinderStub(scripture: scripture)
                    let interactor = SearchViewInteractor(scriptureFinder: scriptureFinder)
                    let appState = AppState(
                        status: .loadedBibles,
                        scripture: scripture
                    )
                    
                    interactor.updateAbbreviationText(in: appState)
                    
                    let expectText = "창 1:1"
                    expect(appState.abbreviationText).to(equal(expectText))
                }
            }
            
            context("Scripture name, bible, chapter, verses가 연속적인 경우") {
                it("abbreviationText는 약어 + chapter + verses 범위를 업데이트한다.") {
                    let scripture = Scripture(
                        name: "창세",
                        bible: bible,
                        chapter: 1,
                        verses: [1, 2, 3]
                    )
                    let scriptureFinder = ScriptureFinderStub(scripture: scripture)
                    let interactor = SearchViewInteractor(scriptureFinder: scriptureFinder)
                    let appState = AppState(
                        status: .loadedBibles,
                        scripture: scripture
                    )
                    
                    interactor.updateAbbreviationText(in: appState)
                    
                    let expectText = "창 1:1-3"
                    expect(appState.abbreviationText).to(equal(expectText))
                }
            }
            
            context("Scripture name, bible, chapter, verses가 연속이지 않은 경우") {
                it("abbreviationText는 약어 + chapter + verses를 업데이트한다.") {
                    let scripture = Scripture(
                        name: "창세",
                        bible: bible,
                        chapter: 1,
                        verses: [1, 3, 5]
                    )
                    let scriptureFinder = ScriptureFinderStub(scripture: scripture)
                    let interactor = SearchViewInteractor(scriptureFinder: scriptureFinder)
                    let appState = AppState(
                        status: .loadedBibles,
                        scripture: scripture
                    )
                    
                    interactor.updateAbbreviationText(in: appState)
                    
                    let expectText = "창 1:1, 3, 5"
                    expect(appState.abbreviationText).to(equal(expectText))
                }
            }
        }
    }
}
