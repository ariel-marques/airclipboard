//
//  AppEnvironment.swift
//  AirClipboard
//
//  Created by Ariel Marques on 23/04/25.
//

import SwiftUI

class AppEnvironment: ObservableObject {
    static let shared = AppEnvironment()

    // MARK: - Idioma
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "system"

    var locale: Locale {
        switch selectedLanguage {
        case "pt": return Locale(identifier: "pt_BR")
        case "en": return Locale(identifier: "en_US")
        default: return Locale.current
        }
    }

    func updateLanguage(_ newValue: String) {
        selectedLanguage = newValue
        UserDefaults.standard.set(newValue, forKey: "selectedLanguage")
        objectWillChange.send() // ⚠️ Atualiza os observadores
    }

    // MARK: - Tema
    @Published var selectedTheme: AppTheme = {
        let rawValue = UserDefaults.standard.string(forKey: "selectedAppTheme") ?? "system"
        return AppTheme(rawValue: rawValue) ?? .system
    }()

    var colorScheme: ColorScheme? {
        selectedTheme.colorScheme
    }

    func updateTheme(_ newValue: AppTheme) {
        selectedTheme = newValue
        UserDefaults.standard.set(newValue.rawValue, forKey: "selectedAppTheme")
        objectWillChange.send()
    }

    private init() {}
}
