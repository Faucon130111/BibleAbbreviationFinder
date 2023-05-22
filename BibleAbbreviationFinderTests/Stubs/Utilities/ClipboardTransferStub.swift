//
//  ClipboardTransferStub.swift
//  BibleAbbreviationFinderTests
//
//  Created by faucon130111 on 2023/05/17.
//

import Combine
@testable import BibleAbbreviationFinder

struct ClipboardTransferStub: ClipboardTransfer {
    func send(_ string: String) -> AnyPublisher<Bool, Errors> {
        return Just<Bool>(true)
            .setFailureType(to: Errors.self)
            .eraseToAnyPublisher()
    }
}
