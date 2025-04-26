//
//  AdvancedPreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 13/04/25.
//

import SwiftUI

struct AdvancedPreferencesView: View {
    @AppStorage("maxFileSizeMB") private var maxFileSizeMB: Int = 10

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Título
            Text("preferences_advanced_title")
                .font(.title2)
                .fontWeight(.semibold)

            // ⏸️ Opção de tamanho máximo ocultada temporariamente
            /*
            HStack(spacing: 12) {
                Text("preferences_advanced_max_size_label")
                    .fontWeight(.medium)
                    .padding(.trailing, 20)

                Text("\(maxFileSizeMB)")
                    .font(.body)
                    .frame(width: 50)
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3))
                    )

                Stepper("", value: $maxFileSizeMB, in: 1...100)
                    .padding(.leading, -11)
                    .frame(width: 0.1)
            }

            Text("preferences_advanced_description")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
            */

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
