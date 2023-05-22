//
//  BibleLoadingInteractor.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/12.
//

import Combine

protocol BibleLoadingInteractorSpec {
    func loadBibles(in appState: AppState)
}

struct BibleLoadingInteractor: BibleLoadingInteractorSpec {
    var repository: BibleRepository
    
    func loadBibles(in appState: AppState) {
        _ = repository
            .loadBibles()
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    appState.occurredError = error
                }
            }) {
                appState.bibles = $0
                appState.status = .loadedBibles
            }
    }
}
