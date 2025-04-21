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
            Text("Avançado")
                .font(.title2)
                .fontWeight(.semibold)

            Stepper(value: $maxFileSizeMB, in: 1...100) {
                Text("Tamanho máximo do arquivo: \(maxFileSizeMB) MB")
            }
            .frame(maxWidth: 280)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
