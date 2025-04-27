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
    
    // MARK: - Shake Gesture
    @AppStorage("enableShakeGesture") var enableShakeGesture: Bool = true
    @AppStorage("shakeModifier") var shakeModifier: String = "shift"
    enum ShakeModifierKey: String, CaseIterable {
        case shift, command, option
    }

    @AppStorage("selectedShakeModifier") var selectedShakeModifier: String = ShakeModifierKey.shift.rawValue

    var currentShakeModifier: NSEvent.ModifierFlags {
        switch ShakeModifierKey(rawValue: selectedShakeModifier) ?? .shift {
        case .shift:
            return .shift
        case .command:
            return .command
        case .option:
            return .option
        }
    }
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
    @Published var licenseStatus: LicenseStatus = .pro_lifetime

    func updateLicenseStatus(_ newValue: LicenseStatus) {
        licenseStatus = newValue
        UserDefaults.standard.set(newValue.rawValue, forKey: "licenseStatus")
        objectWillChange.send()
    }
    
    // MARK: - Trial
       @AppStorage("trialStartDate") private var trialStartDateString: String = ""
       let trialDurationDays: Int = 7

       var isTrialActive: Bool {
           if licenseStatus == .trial {
               return trialDaysLeft > 0
           }
           return false
       }

       var trialDaysLeft: Int {
           guard let startDate = trialStartDate else { return 0 }
           let elapsed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
           let remaining = trialDurationDays - elapsed
           return max(remaining, 0)
       }

       private var trialStartDate: Date? {
           guard !trialStartDateString.isEmpty else { return nil }
           return ISO8601DateFormatter().date(from: trialStartDateString)
       }

       func startTrialIfNeeded() {
           if trialStartDate == nil {
               trialStartDateString = ISO8601DateFormatter().string(from: Date())
               print("🆕 Trial iniciado em: \(trialStartDateString)")
           }
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
        
        // 🚫 Não força mais licença no init!
    }
}
