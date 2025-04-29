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

    @State private var tempShortcut: String = ""
    @State private var isHoveringX: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    .frame(width: 140, height: 24)

                Text(displayedText)
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                    .frame(width: 130, height: 24)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tempShortcut = recordedShortcut
                        isRecording = true
                        recordedShortcut = ""
                    }

                if isRecording {
                    KeyboardEventCatcher(
                        isRecording: $isRecording,
                        shortcut: $recordedShortcut
                    ) {
                        HotkeyManager.shared.updateShortcut(recordedShortcut)
                    }
                    .frame(width: 0, height: 0)
                }
            }

            if isRecording || !recordedShortcut.isEmpty {
                Button(action: {
                    if isRecording {
                        recordedShortcut = tempShortcut
                    } else {
                        recordedShortcut = ""
                    }
                    isRecording = false
                    HotkeyManager.shared.updateShortcut(recordedShortcut)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .opacity(isHoveringX ? 1.0 : 0.5)
                        .font(.system(size: 13))
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isHoveringX = hovering
                    }
                }
                .padding(.trailing, 2)
            }
        }
        .help("shortcut_field_help")
    }

    private var displayedText: String {
        if isRecording {
            if recordedShortcut.isEmpty {
                return isHoveringX ? NSLocalizedString("cancel_button_label", comment: "") : NSLocalizedString("shortcut_field_placeholder", comment: "")
            } else {
                return recordedShortcut
            }
        } else {
            return recordedShortcut.isEmpty ? NSLocalizedString("shortcut_field_placeholder", comment: "") : recordedShortcut
        }
    }
}
