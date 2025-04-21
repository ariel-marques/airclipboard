//
//  ShortcutFieldView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 17/04/25.
//

import SwiftUI

struct ShortcutFieldView: View {
    @Binding var isRecording: Bool
    @Binding var recordedShortcut: String

    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                .frame(width: 100, height: 22)

            // Centraliza o texto
            Text(recordedShortcut.isEmpty ? "Digitar atalho" : recordedShortcut)
                .font(.system(size: 11))
                .foregroundColor(.primary)
                .frame(width: 100, height: 22, alignment: .center)
                .contentShape(Rectangle())
                .onTapGesture {
                    isRecording = true
                    recordedShortcut = ""
                }

            // Botão "X" no canto
            if isRecording || !recordedShortcut.isEmpty {
                Button(action: {
                    recordedShortcut = ""
                    isRecording = false
                    HotkeyManager.shared.updateShortcut("")
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 10))
                }
                .buttonStyle(.plain)
                .help("Cancelar")
                .padding(.trailing, 4)
            }

            // Captura de atalho invisível
            if isRecording {
                KeyboardEventCatcher(
                    isRecording: $isRecording,
                    shortcut: $recordedShortcut
                ) {
                    HotkeyManager.shared.updateShortcut(recordedShortcut)
                    print("✅ Novo atalho definido: \(recordedShortcut)")
                }
                .frame(width: 0, height: 0)
            }
        }
        .help("Clique para definir um atalho global.\nSugestões: ⌃⌘V, ⌥⌘C, ⇧⌘X")
    }
}
