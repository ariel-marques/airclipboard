//
//  AppearancePreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 13/04/25.
//

import SwiftUI

struct AppearancePreferencesView: View {
    @AppStorage("selectedAppTheme") private var selectedTheme: AppTheme = .system

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Título da seção
            Text("Aparência")
                .font(.title2)
                .fontWeight(.semibold)

            // Seletor de tema
            HStack(spacing: 12) {
                Text("Estilo de tema:")
                    .fontWeight(.medium)

                Picker("", selection: $selectedTheme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.label).tag(theme)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: 180)
            }

            Text("Escolha entre claro, escuro ou acompanhe o sistema.")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
