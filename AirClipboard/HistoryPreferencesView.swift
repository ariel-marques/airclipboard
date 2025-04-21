//
//  HistoryPreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 13/04/25.
//

import SwiftUI

struct HistoryPreferencesView: View {
    @AppStorage("historyLimit") private var historyLimit: Int = 50

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Título da seção
            Text("Histórico")
                .font(.title2)
                .fontWeight(.semibold)

            // Campo com stepper
            Stepper(value: $historyLimit, in: 10...500, step: 10) {
                Text("Limite de itens salvos: \(historyLimit)")
            }
            .frame(maxWidth: 280)

            // Descrição
            Text("Defina o número máximo de itens mantidos no histórico. O valor padrão é 50.")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
