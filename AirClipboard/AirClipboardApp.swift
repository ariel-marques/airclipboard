//
//  AirClipboardApp.swift
//  AirClipboard
//
//  Created by Ariel Marques on 18/04/25.
//

import SwiftUI

@main
struct AirClipboardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var environment = AppEnvironment.shared

    var body: some Scene {
        MenuBarExtra {
            MenuBarContent()
                .id(environment.selectedLanguage)
        } label: {
            Image("MenuBarIcon")
                .renderingMode(.template)
        }
        .menuBarExtraStyle(.window)
        .environment(\.locale, environment.locale)
    }
}
