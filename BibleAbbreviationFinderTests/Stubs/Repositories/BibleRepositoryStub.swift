//
//  BibleRepositoryStub.swift
//  BibleAbbreviationFinderTests
//
//  Created by faucon130111 on 2023/05/03.
//

import Combine
@testable import BibleAbbreviationFinder

struct BibleRepositoryStub: BibleRepository {
    var bibles: [Bible]
    var error: Errors?

    func loadBibles() -> AnyPublisher<[Bible], Errors> {
        if let error = error {
            return Fail<[Bible], Errors>(error: error)
                .eraseToAnyPublisher()
        }
        
        return Just<[Bible]>(bibles)
            .setFailureType(to: Errors.self)
            .eraseToAnyPublisher()
    }
}
