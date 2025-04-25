//
//  AppEnvironment.swift
//  AirClipboard
//
//  Created by Ariel Marques on 23/04/25.
//

import SwiftUI

enum LicenseStatus: String {
    case free
    case trial
    case pro_lifetime
    case pro_monthly
}

class AppEnvironment: ObservableObject {
    static let shared = AppEnvironment()

    // MARK: - Idioma
    @Published var selectedLanguage: String

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
        objectWillChange.send()
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

    // MARK: - Licença
    @Published var licenseStatus: LicenseStatus = {
        let rawValue = UserDefaults.standard.string(forKey: "licenseStatus") ?? "free"
        return LicenseStatus(rawValue: rawValue) ?? .free
    }()

    func updateLicenseStatus(_ newValue: LicenseStatus) {
        licenseStatus = newValue
        UserDefaults.standard.set(newValue.rawValue, forKey: "licenseStatus")
        objectWillChange.send()
    }

    // MARK: - Init com lógica de idioma inteligente
    private init() {
        let saved = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "system"
        if saved == "system" {
            let region = Locale.current.identifier
            if region.contains("pt") {
                selectedLanguage = "pt"
            } else {
                selectedLanguage = "en"
            }
        } else {
            selectedLanguage = saved
        }
    }
}
