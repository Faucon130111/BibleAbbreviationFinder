//
//  StringClipboardTransfer.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/16.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Combine

protocol ClipboardTransfer {
    func send(_ string: String) -> AnyPublisher<Bool, Errors>
}

struct StringClipboardTransfer: ClipboardTransfer {
    func send(_ string: String) -> AnyPublisher<Bool, Errors> {
#if os(iOS)
            UIPasteboard.general.string = string
#elseif os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(
                string,
                forType: .string
            )
#endif
        return Just<Bool>(true)
            .setFailureType(to: Errors.self)
            .eraseToAnyPublisher()
    }
}
