//
//  ScriptureFinderStub.swift
//  BibleAbbreviationFinderTests
//
//  Created by faucon130111 on 2023/05/17.
//

import Combine
@testable import BibleAbbreviationFinder

struct ScriptureFinderStub: ScriptureFinderSpec {
    var scripture: Scripture
    
    func analyze(for text: String) -> Just<Scripture> {
        return Just<Scripture>(scripture)
    }
}
