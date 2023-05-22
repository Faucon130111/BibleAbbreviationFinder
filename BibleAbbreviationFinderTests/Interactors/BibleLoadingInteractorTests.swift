//
//  BibleLoadingInteractorTests.swift
//  BibleAbbreviationFinderTests
//
//  Created by faucon130111 on 2023/05/15.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Combine
import Quick
import Nimble
@testable import BibleAbbreviationFinder

final class BibleLoadingInteractorTests: QuickSpec {
    override func spec() {
        describe("BibleLoadingInteractor") {
            context("loadBibles를 실패한 경우") {
                it("AppState.occurredError를 업데이트 한다.") {
                    let appState = AppState(status: .loadingBible)
                    let error: Errors = .invalidData
                    let repository = BibleRepositoryStub(
                        bibles: [],
                        error: error
                    )
                    let interactor = BibleLoadingInteractor(repository: repository)
                    
                    interactor.loadBibles(in: appState)
                    
                    expect(appState.status).to(equal(.loadingBible))
                    expect(appState.bibles).to(beEmpty())
                    expect(appState.occurredError).to(matchError(error))
                }
            }
            
            context("loadBibles를 성공하면") {
                it("AppState.bibles를 업데이트 하고, AppState.status를 .loadedBibles로 변경한다.") {
                    let appState = AppState(status: .loadingBible)
                    let bibles: [Bible] = [
                        Bible(
                            name: "창세기",
                            abbreviation: "창"
                        ),
                        Bible(
                            name: "출애굽기",
                            abbreviation: "출"
                        )
                    ]
                    let repository = BibleRepositoryStub(bibles: bibles)
                    let interactor = BibleLoadingInteractor(repository: repository)
                    
                    interactor.loadBibles(in: appState)
                    
                    expect(appState.status).to(equal(.loadedBibles))
                    expect(appState.bibles).to(equal(bibles))
                }
            }
        }
    }
}
