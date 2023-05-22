//
//  ContentView.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/03.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.interactors) private var interactors: Interactors
   
    var body: some View {
        VStack {
            content
            Spacer()
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .onAppear {
            interactors
                .bibleLoadingInteractor
                .loadBibles(in: appState)
        }
        .errorAlert($appState.occurredError)
    }
    
    @ViewBuilder var content: some View {
        switch appState.status {
        case .loadingBible:
            loadingView
            
        case .loadedBibles:
            VStack(alignment: .leading) {
                SearchView()
                    .environmentObject(appState)
                    .environment(\.interactors, interactors)
                SettingsView(
                    isCopyToClipboard: $appState.isCopyToClipboard,
                    isSaveToFile: $appState.isSaveToFile,
                    filePath: $appState.filePath
                )
            }
            
        }
    }
    
    var loadingView: some View {
        VStack(alignment: .center) {
            Spacer()
            ProgressView {
                Text("Loading...")
                    .font(.headline)
                    .padding()
            }
            .padding()
            Spacer()
        }
    }
}
