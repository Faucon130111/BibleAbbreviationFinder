//
//  StringFileTransfer.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/16.
//

import Combine

protocol FileTransfer {
    func send(
        _ string: String,
        filePath: String?
    ) -> AnyPublisher<Bool, Errors>
}

struct StringFileTransfer: FileTransfer {
    func send(
        _ string: String,
        filePath: String?
    ) -> AnyPublisher<Bool, Errors> {
        guard let filePath = filePath
        else {
            return Fail<Bool, Errors>(error: Errors.invalidFilePath)
                .eraseToAnyPublisher()
        }
        
        do {
            try string.write(
                toFile: filePath,
                atomically: false,
                encoding: .utf8
            )
            return Just<Bool>(true)
            .setFailureType(to: Errors.self)
            .eraseToAnyPublisher()
            
        } catch {
            return Fail<Bool, Errors>(error: Errors.saveToFileFail(error.localizedDescription))
                .eraseToAnyPublisher()
        }
    }
}
