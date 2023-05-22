//
//  ScriptureFinder.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/03.
//

import Foundation
import Combine

protocol ScriptureFinderSpec {
    func analyze(for text: String) -> Just<Scripture>
}

struct ScriptureFinder: ScriptureFinderSpec {    
    func analyze(for text: String) -> Just<Scripture> {
        if text.isEmpty {
            return Just<Scripture>(.empty)
        }
        
        let (name, chapter) = findNameAndChapter(for: text)
        let verses: [Int]? = findVerses(for: text)
        
        let scripture = Scripture(
            name: name,
            chapter: chapter,
            verses: verses
        )

        return Just<Scripture>(scripture)
    }
    
    private func findNameAndChapter(for text: String) -> (
        name: String?,
        chapter: Int?
    ) {
        let pattern = "([가-힣]+)\\s?(\\d+)?:?"
        let words = text.matchingWords(with: pattern)
        var name: String?
        var chapter: Int?
        
        if words.count == 3 {
            name = words[1]
            chapter = Int(words[2])
        } else if words.count == 2 {
            name = words[1]
        }
        return (
            name,
            chapter
        )
    }
    
    private func findVerses(for text: String) -> [Int]? {
        if text.contains(",") {
            let pattern = ":(\\d+)|,\\s?(\\d+)?"
            var words = text.matchingWords(with: pattern)
            words.removeFirst()
            return words.compactMap { Int($0) }
        }
        
        let pattern = ":(\\d+)-?(\\d+)?"
        let words = text.matchingWords(with: pattern)
        
        if words.count == 2 {
            if let verse = Int(words[1]) {
                return [verse]
            }
        } else if words.count == 3 {
            if let start = Int(words[1]),
               let end = Int(words[2]),
               start < end {
                return (start...end).map { $0 }
            }
        }
        return nil
    }
}

extension String {
    func matchingWords(with pattern: String) -> [String] {
        let regexp = try? NSRegularExpression(pattern: pattern)
        let matches = regexp?.matches(
            in: self,
            range: NSRange(
                location: 0,
                length: self.count
            )
        )
        var words: [String] = []
        matches?.forEach { match in
            for i in (0..<match.numberOfRanges) {
                if let range = Range(
                    match.range(at: i),
                    in: self
                ) {
                    let word = String(self[range])
                    words.append(word)
                }
            }
        }
        return words
    }
}
