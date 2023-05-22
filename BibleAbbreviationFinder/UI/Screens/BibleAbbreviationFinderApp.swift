//
//  BibleAbbreviationFinderApp.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/03.
//

import SwiftUI
import Combine

@main
struct BibleAbbreviationFinderApp: App {
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    
    var appState = AppState(status: .loadingBible)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.interactors, .defaultValue)
        }
    }
}
