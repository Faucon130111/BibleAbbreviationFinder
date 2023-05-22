//
//  Bible.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/03.
//

import Foundation

struct Bible: Codable, Equatable {
    var name: String
    var abbreviation: String
}

extension Bible: Identifiable {
    var id: String {
        return name
    }
}
