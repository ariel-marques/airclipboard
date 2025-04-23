//
//  PreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 12/04/25.
//

import SwiftUI

enum PreferencesSection: String, CaseIterable, Identifiable {
    case general, history, language, advanced, license, about

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .general: return "gearshape"
        case .history: return "clock.arrow.circlepath"
        case .language: return "globe"
        case .advanced: return "slider.horizontal.3"
        case .license: return "key"
        case .about: return "laptopcomputer"
        }
    }

    var localizedTitle: String {
        switch self {
        case .general: return String(localized: "section_general")
        case .history: return String(localized: "section_history")
        case .language: return String(localized: "section_language")
        case .advanced: return String(localized: "section_advanced")
        case .license: return String(localized: "section_license")
        case .about: return String(localized: "section_about")
        }
    }
}

struct PreferencesView: View {
    @State private var selectedSection: PreferencesSection = .general

    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            VStack(alignment: .leading, spacing: 0) {
                List(PreferencesSection.allCases, id: \.self, selection: $selectedSection) { section in
                    Label(section.localizedTitle, systemImage: section.icon)
                        .padding(.vertical, 6)
                        .tag(section)
                }
                .listStyle(.sidebar) // ✅ Nova API mais semântica
            }
            .frame(minWidth: 180, idealWidth: 200, maxWidth: 220)
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            // Conteúdo da seção
            VStack(alignment: .leading) {
                contentForSelectedSection(selectedSection)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(24)
        }
        .frame(minWidth: 620, minHeight: 420)
    }

    @ViewBuilder
    private func contentForSelectedSection(_ section: PreferencesSection) -> some View {
        switch section {
        case .general:
            GeneralPreferencesView()
        case .history:
            HistoryPreferencesView()
        case .language:
            LanguagePreferencesView()
        case .advanced:
            AdvancedPreferencesView()
        case .license:
            LicensePreferencesView()
        case .about:
            AboutPreferencesView()
        }
    }
}
