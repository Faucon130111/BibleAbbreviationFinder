//
//  StringClipboardTransferTests.swift
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

final class StringClipboardTransferTests: QuickSpec {
    override func spec() {
        describe("StringClipboardTransfer") {
            context("문자열 클립보드 복사를 실행하면") {
                it("정상적으로 처리된다.") {
                    let transfer = StringClipboardTransfer()
                    let testString = "Test String!"
                    var isSuccess: Bool = false
                    var pasteboardString: String?
                    
                    _ = transfer
                        .send(testString)
                        .sink(receiveCompletion: { _ in }) {
                            isSuccess = $0
#if os(iOS)
                            pasteboardString = UIPasteboard.general.string
#elseif os(macOS)
                            pasteboardString = NSPasteboard.general.string(forType: .string)
#endif
                        }
                    
                    expect(isSuccess).to(beTrue())
                    expect(pasteboardString).to(equal(testString))
                }
            }
        }
    }
}
