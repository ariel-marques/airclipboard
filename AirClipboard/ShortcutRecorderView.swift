//
//  ShortcutRecorderView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 17/04/25.
//

import SwiftUI

struct ShortcutRecorderView: View {
    @State private var isRecording = false
    @AppStorage("shortcutKey") private var recordedShortcut: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text("Atalho Global")
                    .font(.headline)
                    .frame(width: 100, alignment: .leading)

                ShortcutFieldView(
                    isRecording: $isRecording,
                    recordedShortcut: $recordedShortcut
                )
            }

            Text("Pressione o atalho desejado para abrir o ɅirClipboard.")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("⚠️ Alguns atalhos simples como ⌃V podem não funcionar corretamente em certos apps. Recomendamos ⌃⌘V, ⌥⌘C ou combinações com Shift.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.top, 2)

            Spacer()
        }
        .onChange(of: recordedShortcut) { newValue in
            HotkeyManager.shared.updateShortcut(newValue)
        }
        .padding(.top, 4)
    }
}
