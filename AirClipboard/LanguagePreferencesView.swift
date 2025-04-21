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

        var label: String {
            switch self {
            case .system: return "Padrão do Sistema"
            case .english: return "English"
            case .portuguese: return "Português"
            }
        }
    }

    @AppStorage("selectedLanguage") private var selectedLanguage: AppLanguage = .system

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Idioma")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 8) {
                Picker("Idioma do aplicativo", selection: $selectedLanguage) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.label).tag(language)
                    }
                }
                .pickerStyle(.menu) // 👈 estilo pull-down
                .frame(width: 300)

                Text("Você pode precisar reiniciar o aplicativo para aplicar a mudança.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    LanguagePreferencesView()
}
