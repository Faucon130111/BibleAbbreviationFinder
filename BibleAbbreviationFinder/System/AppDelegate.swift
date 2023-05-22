//
//  AppDelegate.swift
//  BibleAbbreviationFinder
//
//  Created by faucon130111 on 2023/05/04.
//

#if os(macOS)
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
#endif
