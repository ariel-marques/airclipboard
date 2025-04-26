//
//  AirClipboardView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 03/04/25.
//

import SwiftUI

struct AirClipboardView: View {
    @EnvironmentObject var history: ClipboardHistory
    @State private var searchText = ""

    var filteredItems: [ClipboardItem] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !trimmed.isEmpty else {
            return history.history
        }

        return history.history.filter { item in
            switch item.type {
            case .text(let value):
                return value.lowercased().contains(trimmed)
            default:
                return true
            }
        }
    }

    var body: some View {
        print("🧩 AirClipboardView foi renderizada")

        return VStack(spacing: 0) {
            HeaderView()
            SearchBar(text: $searchText)
            
            // 🔔 Contador de trial (se aplicável)
            TrialStatusView()

            // 🔒 Aviso visual se o trial expirou
            if AppEnvironment.shared.licenseStatus == .trial && !AppEnvironment.shared.isTrialActive {
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "hourglass.bottomhalf.fill")
                        .foregroundColor(.orange)

                    Text("trial_expired_message")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    Spacer()

                    Button(action: {
                        AppDelegate.shared?.showPreferences(selecting: .license)
                    }) {
                        Text("upgrade_button_label")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.15))
                            .foregroundColor(.accentColor)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }

            ScrollView {
                LazyVStack(spacing: 0) {
                    Spacer(minLength: 8)

                    ForEach(Array(filteredItems.enumerated()), id: \.element.id) { index, item in
                        let isLocked = AppEnvironment.shared.licenseStatus == .free && index >= 3

                        ZStack {
                            ClipboardItemView(item: item)
                                .blur(radius: isLocked ? 4 : 0)
                                .overlay(
                                    Group {
                                        if isLocked {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black.opacity(0.25))
                                                .overlay(
                                                    Image(systemName: "lock.fill")
                                                        .font(.title2)
                                                        .foregroundColor(.white.opacity(0.85))
                                                )
                                        }
                                    }
                                )
                                .disabled(isLocked)
                                .help(isLocked ? LocalizedStringKey("upgrade_tooltip") : "")
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
            }
        }
        .frame(width: 400, height: 500)
        .background(Material.ultraThin)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 10)
    }
}

#Preview {
    AirClipboardView()
        .environmentObject(ClipboardHistory())
}
