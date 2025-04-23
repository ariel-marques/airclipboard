//
//  AppTheme.swift
//  AirClipboard
//
//  Created by Ariel Marques on 13/04/25.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { self.rawValue }

    var label: String {
        switch self {
        case .system: return "Automático"
        case .light: return "Claro"
        case .dark: return "Escuro"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    static var current: AppTheme {
        AppTheme(rawValue: UserDefaults.standard.string(forKey: "selectedAppTheme") ?? "System") ?? .system
    }
}
