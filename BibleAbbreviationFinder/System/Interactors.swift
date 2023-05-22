//
//  Interactors.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/08.
//

import SwiftUI

struct Interactors: EnvironmentKey {
    let bibleLoadingInteractor: BibleLoadingInteractorSpec
    let searchViewInteractor: SearchViewInteractorSpec
    let stringTransferInteractor: StringTransferInteractorSpec
    
    static var defaultValue: Self { Self.default }
    
    private static var `default`: Interactors {
        let jsonURL = Bundle.main.url(
            forResource: "bibles",
            withExtension: "json"
        )!
        let jsonData = try? Data(contentsOf: jsonURL)
        let bibleRepository = JSONBibleRepository(for: jsonData)
        let scriptureFinder = ScriptureFinder()
        let clipboardTransfer = StringClipboardTransfer()
        let fileTransfer = StringFileTransfer()
        return Interactors(
            bibleLoadingInteractor: BibleLoadingInteractor(repository: bibleRepository),
            searchViewInteractor: SearchViewInteractor(scriptureFinder: scriptureFinder),
            stringTransferInteractor: StringTransferInteractor(
                clipboardTransfer: clipboardTransfer,
                fileTransfer: fileTransfer
            )
        )
    }
}

extension EnvironmentValues {
    var interactors: Interactors {
        get { self[Interactors.self] }
        set { self[Interactors.self] = newValue }
    }
}
