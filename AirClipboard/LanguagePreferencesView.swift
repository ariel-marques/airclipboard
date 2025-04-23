//
//  LanguagePreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 13/04/25.
//

import SwiftUI

struct LanguagePreferencesView: View {
    enum AppLanguage: String, CaseIterable, Identifiable, Codable {
        case system
        case english = "en"
        case portuguese = "pt"

        var id: String { rawValue }

        var label: LocalizedStringKey {
            switch self {
            case .system: return "language_option_system"
            case .english: return "language_option_english"
            case .portuguese: return "language_option_portuguese"
            }
        }
    }

    @AppStorage("selectedLanguage") private var selectedLanguage: AppLanguage = .system

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("preferences_language_title")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 8) {
                Picker("preferences_language_picker_label", selection: $selectedLanguage) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.label).tag(language)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 300)
                .onChange(of: selectedLanguage) { newValue in
                    AppEnvironment.shared.updateLanguage(newValue.rawValue)
                }

                Text("preferences_language_note")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
