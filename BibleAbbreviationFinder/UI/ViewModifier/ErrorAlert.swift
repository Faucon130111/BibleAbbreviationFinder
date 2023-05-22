//
//  ErrorAlert.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/16.
//

import SwiftUI
import Combine

struct ErrorAlert: ViewModifier {
    @Binding var error: Errors?
    private var isShowError: Binding<Bool> {
        Binding {
            error != nil
        } set: { _ in
            error = nil
        }
    }
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: isShowError) {
                let message = error?.errorDescription ?? "알 수 없는 오류"
                return Alert(
                    title: Text("오류 발생"),
                    message: Text(message)
                )
            }
    }
}

extension View {
    func errorAlert(_ error: Binding<Errors?>) -> some View {
        modifier(ErrorAlert(error: error))
    }
}
