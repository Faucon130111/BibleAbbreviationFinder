//
//  Errors.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/16.
//

import Foundation

enum Errors: LocalizedError {
    case invalidFilePath
    case saveToFileFail(String)
    case invalidData
    case decodeFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidFilePath:
            return "파일 경로를 확인하세요."
            
        case let .saveToFileFail(errorMessage):
            return "파일 저장에 실패했습니다.\n(\(errorMessage))"
            
        case .invalidData:
            return "잘못된 형식의 파일입니다."
            
        case let .decodeFailed(errorMessage):
            return "잘못된 형식의 파일입니다.\n(\(errorMessage)"
            
        }
    }
}
