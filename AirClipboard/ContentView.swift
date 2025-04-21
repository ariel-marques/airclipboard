//
//  ContentView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 02/04/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var history = ClipboardHistory()
    @State private var clipboardMonitor: ClipboardMonitor?
    @AppStorage("selectedAppTheme") private var selectedTheme: AppTheme = .system

    var body: some View {
        AirClipboardView()
            .environmentObject(history)
            .preferredColorScheme(mapTheme(selectedTheme))
            .onAppear {
                if clipboardMonitor == nil {
                    clipboardMonitor = ClipboardMonitor(history: history)
                    clipboardMonitor?.startMonitoring()
                    print("📋 Monitoramento da área de transferência iniciado!")
                }
            }
    }

    private func mapTheme(_ theme: AppTheme) -> ColorScheme? {
        switch theme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
