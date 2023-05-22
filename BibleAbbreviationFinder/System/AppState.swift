//
//  AppState.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/03.
//

import SwiftUI

final class AppState: ObservableObject {
    @Published var status: Status
    @Published var bibles: [Bible]
    @Published var occurredError: Errors?

    @Published var abbreviationText: String = ""
    var scripture: Scripture
    
    @Published var isCopyToClipboard: Bool = false
    @Published var isSaveToFile: Bool = false
    @Published var filePath: String?
    
    init(
        status: Status,
        bibles: [Bible] = [],
        scripture: Scripture = .empty
    ) {
        self.status = status
        self.bibles = bibles
        self.scripture = scripture
    }
}

extension AppState {
    enum Status {
        case loadingBible
        case loadedBibles
    }
}
