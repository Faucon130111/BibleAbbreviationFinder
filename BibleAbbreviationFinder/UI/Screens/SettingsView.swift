//
//  SettingsView.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/10.
//

import SwiftUI

struct SettingsView: View {    
    @Binding var isCopyToClipboard: Bool
    @Binding var isSaveToFile: Bool
    @Binding var filePath: String?
    
    var body: some View {
        Toggle(isOn: $isCopyToClipboard) {
            Text("결과를 클립보드에 복사")
                .font(.callout)
        }
#if os(macOS)
        HStack {
            Toggle(isOn: $isSaveToFile) {
                Text("결과를 파일에 복사")
                    .font(.callout)
            }
            Spacer()
            Button("파일 선택") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false              
                if panel.runModal() == .OK {
                    if let url = panel.url {
                        filePath = String(url.absoluteString.dropFirst(7))
                    }
                }
            }
            .font(.callout)
            .disabled(isSaveToFile == false)
        }
        if isSaveToFile {
            HStack {
                Spacer()
                Text(filePath ?? "선택된 파일이 없습니다.")
                    .font(.footnote)
                    .foregroundColor(filePath == nil ? .red : .blue)
            }
        }
#endif
    }
}
