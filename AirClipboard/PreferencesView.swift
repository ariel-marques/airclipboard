//
//  PreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 12/04/25.
//

import SwiftUI

enum PreferencesSection: String, CaseIterable, Identifiable {
    case general, history, language, advanced, license, about

    var id: String { self.rawValue }

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

    var localizedTitle: LocalizedStringKey {
        switch self {
        case .general: return "section_general"
        case .history: return "section_history"
        case .language: return "section_language"
        case .advanced: return "section_advanced"
        case .license: return "section_license"
        case .about: return "section_about"
        }
    }
}

struct PreferencesView: View {
    @State private var selectedSection: PreferencesSection = .general
    @ObservedObject private var environment = AppEnvironment.shared

    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            VStack(alignment: .leading, spacing: 0) {
                List(PreferencesSection.allCases, id: \.self, selection: $selectedSection) { section in
                    Label(section.localizedTitle, systemImage: section.icon)
                        .padding(.vertical, 6)
                        .tag(section)
                }
                .listStyle(.sidebar)
            }
            .frame(minWidth: 180, idealWidth: 200, maxWidth: 220)
            .onReceive(NotificationCenter.default.publisher(for: .selectPreferencesSection)) { notification in
                if let section = notification.object as? PreferencesSection {
                    selectedSection = section
                }
            }
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            // Conteúdo da seção
            VStack(alignment: .leading) {
                contentForSelectedSection(selectedSection)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(24)
        }
        .environment(\.locale, environment.locale) // 🌍 Aplica idioma dinamicamente
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
