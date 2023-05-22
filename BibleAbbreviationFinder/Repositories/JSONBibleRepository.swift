//
//  JSONBibleRepository.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/03.
//

import Foundation
import Combine

protocol BibleRepository {
    func loadBibles() -> AnyPublisher<[Bible], Errors>
}

struct JSONBibleRepository {
    var data: Data?
    
    init(for data: Data?) {
        self.data = data
    }
}

extension JSONBibleRepository: BibleRepository {
    func loadBibles() -> AnyPublisher<[Bible], Errors> {
        guard let data = data
        else {
            return Fail<[Bible], Errors>(error: Errors.invalidData)
                .eraseToAnyPublisher()
        }
         
        do {
            let bibles = try JSONDecoder().decode(
                [Bible].self,
                from: data
            )
            return Just<[Bible]>(bibles)
                .setFailureType(to: Errors.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail<[Bible], Errors>(error: Errors.decodeFailed(error.localizedDescription))
                .eraseToAnyPublisher()
        }
    }
}
