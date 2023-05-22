//
//  StringTransferInteractor.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/10.
//

import Combine

enum StringTransferAction {
    case copyToClipboard(
        string: String,
        completion: ((Bool) -> Void)?
    )
    case saveToFile(
        string: String,
        filePath: String?,
        completion: ((Bool) -> Void)?
    )
}

protocol StringTransferInteractorSpec {
    func perform(
        actions: [StringTransferAction],
        in appState: AppState
    )
}

struct StringTransferInteractor: StringTransferInteractorSpec {
    var clipboardTransfer: ClipboardTransfer
    var fileTransfer: FileTransfer

    func perform(
        actions: [StringTransferAction],
        in appState: AppState
    ) {
        actions.forEach {
            perform(
                action: $0,
                in: appState
            )
        }
    }
    
    private func perform(
        action: StringTransferAction,
        in appState: AppState
    ) {
        switch action {
        case let .copyToClipboard(string, completion):
            _ = clipboardTransfer.send(string)
                .sink(receiveCompletion: { _ in }) {
                    print("clipboard transfer response: \($0)")
                    completion?(true)
                }
            
        case let .saveToFile(string, filePath, completion):
            _ = fileTransfer.send(
                string,
                filePath: filePath
            )
            .sink(receiveCompletion: {
                if case let .failure(error) = $0 {
                    appState.occurredError = error
                    completion?(false)
                }
            }) {
                print("file transfer response: \($0)")
                completion?(true)
            }
            
        }
    }   
}
