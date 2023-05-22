//
//  StringFileTransferTests.swift
//  BibleAbbreviationFinderTests
//
//  Created by faucon130111 on 2023/05/16.
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

final class StringFileTransferTests: QuickSpec {
    override func spec() {
        describe("StringFileTransfer") {
            let transfer = StringFileTransfer()
            let testString = "Test String!"
            
            context("파일경로가 없을 경우") {
                it("Errors.invalidFilePath 에러가 발생한다.") {
                    var isSuccess: Bool = false
                    var occurredError: Errors?
                    
                    _ = transfer
                        .send(
                            testString,
                            filePath: nil
                        )
                        .sink(receiveCompletion: {
                            if case let .failure(error) = $0 {
                                occurredError = error
                            }
                        }) {
                            isSuccess = $0
                        }
                    
                    expect(isSuccess).to(beFalse())
                    expect(occurredError).to(matchError(Errors.invalidFilePath))
                }
            }
            
            context("파일 쓰기가 실패한 경우") {
                it("Errors.saveToFileFail 에러가 발생한다.") {
                    let filePath = NSTemporaryDirectory()
                    var isSuccess: Bool = false
                    var occurredError: Errors?
                    
                    _ = transfer
                        .send(
                            testString,
                            filePath: filePath
                        )
                        .sink(receiveCompletion: {
                            if case let .failure(error) = $0 {
                                occurredError = error
                            }
                        }) {
                            isSuccess = $0
                        }
                    
                    expect(isSuccess).to(beFalse())
                    expect(occurredError).to(matchError(Errors.saveToFileFail("")))
                }
            }
            
            context("파일 쓰기가 성공한 경우") {
                it("해당 파일에 문자열을 덮어쓴다.") {
                    let tempDir = NSTemporaryDirectory()
                    let filePath = tempDir.appending("temp.txt")
                    var isSuccess: Bool = false
                    var occurredError: Errors?
                    var fileContentString: String?
                    
                    _ = transfer
                        .send(
                            testString,
                            filePath: filePath
                        )
                        .sink(receiveCompletion: {
                            if case let .failure(error) = $0 {
                                occurredError = error
                            }
                        }) {
                            isSuccess = $0
                            fileContentString = try? String(contentsOfFile: filePath)
                        }
                    
                    expect(isSuccess).to(beTrue())
                    expect(occurredError).to(beNil())
                    expect(fileContentString).to(equal(testString))
                }
            }
        }
    }
}
