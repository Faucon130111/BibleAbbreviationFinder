//
//  SearchView.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/08.
//

import SwiftUI
import Combine

struct SearchView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.interactors) private var interactors: Interactors
    
    @State var searchText: String = ""
    @State var filteredBibles: [Bible] = []
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("검색")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField(
                        "검색어를 입력하세요.",
                        text: $searchText
                    )
                    .font(.title2)
                    .overlay(VStack { Divider().offset(x: 0, y: 15) })
                    .onChange(of: searchText) { newText in
                        interactors
                            .searchViewInteractor
                            .perform(
                                action: .analyze(searchText),
                                in: appState
                            )
                    }
#if os(iOS)
                    .submitLabel(.done)
#endif
                }
                HStack {
                    Text("결과")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(appState.abbreviationText)
                        .font(.title2.italic())
                        .underline()
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .onChange(of: appState.abbreviationText) {
                            transferAbbreviation(text: $0)
                        }
                }
            }
            Divider()
            List(filteredBibles) { bible in
                BibleCell(bible: bible)
                    .onTapGesture {
                        interactors
                            .searchViewInteractor
                            .perform(
                                action: .select(bible),
                                in: appState
                            )
                    }
            }
            .onChange(of: appState.scripture) { scripture in
                guard let name = scripture.name
                else {
                    filteredBibles = []
                    return
                }
                
                filteredBibles = appState.bibles
                    .filter { bible in
                        bible.name.contains(name) ||
                        bible.abbreviation.contains(name)
                    }
            }
        }
    }
    
    private func transferAbbreviation(text: String?) {
        guard let string = text
        else {
            return
        }
        
        var actions: [StringTransferAction] = []
        if appState.isCopyToClipboard {
            actions
                .append(.copyToClipboard(
                    string: string,
                    completion: nil
                ))
        }
        if appState.isSaveToFile {
            actions
                .append(.saveToFile(
                string: string,
                filePath: appState.filePath,
                completion: nil
            ))
        }
        
        interactors
            .stringTransferInteractor
            .perform(
                actions: actions,
                in: appState
            )
    }
}
