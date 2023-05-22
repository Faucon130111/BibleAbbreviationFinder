//
//  SearchViewInteractor.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/22.
//

import SwiftUI
import Combine

enum SearchViewAction {
    case analyze(_ text: String)
    case select(_ bible: Bible)
}

protocol SearchViewInteractorSpec {
    func perform(
        action: SearchViewAction,
        in appState: AppState
    )
}

struct SearchViewInteractor: SearchViewInteractorSpec {
    var scriptureFinder: ScriptureFinderSpec
    
    func perform(
        action: SearchViewAction,
        in appState: AppState
    ) {
        switch action {
        case let .analyze(text):
            if text.isEmpty {
                appState.scripture.bible = nil
            }
            
            _ = scriptureFinder
                .analyze(for: text)
                .sink {
                    appState.scripture.name = $0.name
                    appState.scripture.chapter = $0.chapter
                    appState.scripture.verses = $0.verses
                    updateAbbreviationText(in: appState)
                }
            
        case let .select(bible):
            appState.scripture.bible = bible
            updateAbbreviationText(in: appState)
            
        }
    }
    
    func updateAbbreviationText(in appState: AppState) {
        let scripture = appState.scripture
        guard let bible = scripture.bible
        else {
            appState.abbreviationText = ""
            return
        }
        
        var combinedText = bible.abbreviation
        if let chapter = scripture.chapter {
            combinedText += " \(chapter)"
        }
        
        if let verses = scripture.verses,
           verses.count > 0,
           let start = verses.first {
            combinedText += ":"
            
            if verses.count == 1 {
                combinedText += "\(start)"
            } else if let end = verses.last {
                let isContinuous = verses.map { $0 - 1 }.dropFirst() == verses.dropLast()
                if isContinuous {
                    combinedText += "\(start)-\(end)"
                } else {
                    combinedText += verses.map { "\($0)" }.joined(separator: ", ")
                }
            }
        }
        appState.abbreviationText = combinedText
    }
}
