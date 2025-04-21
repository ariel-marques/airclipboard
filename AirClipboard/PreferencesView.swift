//
//  PreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 12/04/25.
//

import SwiftUI

enum PreferencesSection: String, CaseIterable, Identifiable {
    case general = "Geral"
    case appearance = "Aparência"
    case history = "Histórico"
    case language = "Idioma"
    case advanced = "Avançado"
    case license = "Licença"

    var id: String { self.rawValue }

    var icon: String {
        switch self {
        case .general: return "gearshape"
        case .appearance: return "paintbrush"
        case .history: return "clock.arrow.circlepath"
        case .language: return "globe"
        case .advanced: return "slider.horizontal.3"
        case .license: return "key"
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
                    Label(section.rawValue, systemImage: section.icon)
                        .padding(.vertical, 6)
                        .tag(section)
                }
                .listStyle(SidebarListStyle())
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
        case .appearance:
            AppearancePreferencesView()
        case .history:
            HistoryPreferencesView()
        case .language:
            LanguagePreferencesView()
        case .advanced:
            AdvancedPreferencesView()
        case .license:
            LicensePreferencesView()
        }
    }
}
