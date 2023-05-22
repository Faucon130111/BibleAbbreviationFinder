//
//  FileTransferStub.swift
//  BibleAbbreviationFinderTests
//
//  Created by faucon130111 on 2023/05/17.
//

import Combine
@testable import BibleAbbreviationFinder

struct FileTransferStub: FileTransfer {
    var isSuccess: Bool
    var error: Errors?
    
    func send(_ string: String, filePath: String?) -> AnyPublisher<Bool, Errors> {
        if isSuccess {
            return Just<Bool>(true)
                .setFailureType(to: Errors.self)
                .eraseToAnyPublisher()
        }
        
        if let error = error {
            return Fail<Bool, Errors>(error: error)
                .eraseToAnyPublisher()
        }
        
        return Just<Bool>(false)
            .setFailureType(to: Errors.self)
            .eraseToAnyPublisher()
    }
}
