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
            Text("preferences_history_title")
                .font(.title2)
                .fontWeight(.semibold)

            // Campo com número e stepper
            HStack(spacing: 12) {
                Text("preferences_history_limit_label")
                    .fontWeight(.medium)
                    .padding(.trailing, 20)

                Text("\(historyLimit)")
                    .font(.body)
                    .frame(width: 50)
                    .padding(6)
                    .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.3)))

                Stepper("", value: $historyLimit, in: 10...500, step: 10)
                    .padding(.leading, -11)
                    .frame(width: 0.1)
            }

            // Descrição
            Text("preferences_history_description")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
