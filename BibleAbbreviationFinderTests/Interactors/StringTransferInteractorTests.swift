//
//  StringTransferInteractorTests.swift
//  BibleAbbreviationFinderTests
//
//  Created by faucon130111 on 2023/05/11.
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

final class StringTransferInteractorTests: QuickSpec {
    override func spec() {
        describe("StringTransferInteractor") {
            let clipboardTransfer = ClipboardTransferStub()

            context("StringTransferAction이 모두 성공적으로 동작된 경우") {
                it("completion(true) 호출이 모두 이루어진다.") {
                    let appState = AppState(status: .loadedBibles)
                    let fileTransfer = FileTransferStub(isSuccess: true)
                    let interactor = StringTransferInteractor(
                        clipboardTransfer: clipboardTransfer,
                        fileTransfer: fileTransfer
                    )
                    let testString = "Test String!"
                    var clipboardTransferComplete: Bool = false
                    var fileTransferComplete: Bool = false
                    let actions: [StringTransferAction] = [
                        .copyToClipboard(string: testString) {
                            clipboardTransferComplete = $0
                        },
                        .saveToFile(
                            string: testString,
                            filePath: nil
                        ) {
                            fileTransferComplete = $0
                        }
                    ]
                    
                    interactor.perform(
                        actions: actions,
                        in: appState
                    )
                    
                    expect(clipboardTransferComplete).to(beTrue())
                    expect(fileTransferComplete).to(beTrue())
                }
            }
            
            context("StringTransferAction이 실패한 경우") {
                it("AppState.occurredError를 업데이트 하고, completion(false)을 호출한다.") {
                    let appState = AppState(status: .loadedBibles)
                    let fileTransfer = FileTransferStub(
                        isSuccess: false,
                        error: Errors.invalidFilePath
                    )
                    let interactor = StringTransferInteractor(
                        clipboardTransfer: clipboardTransfer,
                        fileTransfer: fileTransfer
                    )
                    let testString = "Test String!"

                    var fileTransferComplete: Bool = false
                    let actions: [StringTransferAction] = [
                        .saveToFile(
                            string: testString,
                            filePath: nil
                        ) {
                            fileTransferComplete = $0
                        }
                    ]
                    
                    interactor.perform(
                        actions: actions,
                        in: appState
                    )
                    
                    expect(appState.occurredError).to(matchError(Errors.invalidFilePath))
                    expect(fileTransferComplete).to(beFalse())
                }
            }
        }
    }
}
