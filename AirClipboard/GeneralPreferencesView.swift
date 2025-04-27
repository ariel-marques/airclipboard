//
//  GeneralPreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 13/04/25.
//

import SwiftUI
import ServiceManagement

struct GeneralPreferencesView: View {
    @AppStorage("playClickSound") private var playClickSound = true
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("shortcutKey") private var recordedShortcut = "⌃⌘V"
    @AppStorage("enableShakeGesture") private var enableShakeGesture = true
    @AppStorage("selectedShakeModifier") private var selectedShakeModifier = "shift"

    @State private var isRecordingShortcut = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Título da seção
            Text("preferences_general_title")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(spacing: 16) {
                preferenceSwitchRow(titleKey: "preferences_click_sound", isOn: $playClickSound)

                preferenceSwitchRow(titleKey: "preferences_launch_at_login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { newValue in
                        if #available(macOS 13.0, *) {
                            do {
                                if newValue {
                                    try SMAppService.mainApp.register()
                                    print("✅ App registrado para iniciar com o sistema")
                                } else {
                                    try SMAppService.mainApp.unregister()
                                    print("🛑 App removido do login automático")
                                }
                            } catch {
                                print("🚫 Erro ao configurar login automático: \(error)")
                            }
                        } else {
                            print("⚠️ Essa função requer macOS 13 ou superior")
                        }
                    }

                Divider()

                preferenceSwitchRow(titleKey: "shake_to_open", isOn: $enableShakeGesture)

                if enableShakeGesture {
                    Picker(LocalizedStringKey("shake_modifier_label"), selection: $selectedShakeModifier) {
                        Text(LocalizedStringKey("modifier_shift")).tag("shift")
                        Text(LocalizedStringKey("modifier_command")).tag("command")
                        Text(LocalizedStringKey("modifier_option")).tag("option")
                    }
                    .pickerStyle(.menu)
                    .padding(.top, 8)

                    Text("shake_modifier_description")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("preferences_shortcut_label")
                    Spacer()
                    ShortcutFieldView(
                        isRecording: $isRecordingShortcut,
                        recordedShortcut: $recordedShortcut
                    )
                }

                Text("preferences_shortcut_description")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("preferences_shortcut_warning")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func preferenceSwitchRow(titleKey: LocalizedStringKey, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(titleKey)
            Spacer()
            Toggle("", isOn: isOn)
                .toggleStyle(.switch)
                .labelsHidden()
        }
    }
}
