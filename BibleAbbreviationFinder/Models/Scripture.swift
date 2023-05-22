//
//  Scripture.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/03.
//

import SwiftUI

struct Scripture {
    var name: String?
    var bible: Bible?
    var chapter: Int?
    var verses: [Int]?
        
    static var empty: Scripture {
        Scripture(
            name: nil,
            bible: nil,
            chapter: nil,
            verses: nil
        )
    }
}

extension Scripture: Equatable {
    static func == (
        lhs: Scripture,
        rhs: Scripture
    ) -> Bool {
        lhs.name == rhs.name &&
        lhs.bible == rhs.bible &&
        lhs.chapter == rhs.chapter &&
        lhs.verses == rhs.verses
    }
}
