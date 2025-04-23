//
//  LanguageManager.swift
//  AirClipboard
//
//  Created by Ariel Marques on 23/04/25.
//

import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    @AppStorage("selectedLanguage") var selectedLanguage: String = "system" {
        didSet {
            objectWillChange.send()
        }
    }

    var locale: Locale {
        switch selectedLanguage {
        case "pt": return Locale(identifier: "pt_BR")
        case "en": return Locale(identifier: "en_US")
        default: return Locale.current
        }
    }
}
