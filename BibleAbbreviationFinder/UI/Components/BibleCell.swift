//
//  BibleCell.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/09.
//

import SwiftUI

struct BibleCell: View {
    var bible: Bible
    
    var body: some View {
        HStack {
            Text("[\(bible.abbreviation)]")
            Text(bible.name)
        }
        .font(.title3)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .border(.gray.opacity(0.3))
        .contentShape(Rectangle())
#if os(iOS)
        .listRowSeparator(.hidden)
#endif
    }
}
