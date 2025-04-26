//
//  LicensePreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 13/04/25.
//

import SwiftUI

struct LicensePreferencesView: View {
    @AppStorage("licenseEmail") private var licenseEmail: String = ""
    @AppStorage("licenseKey") private var licenseKey: String = ""
    @AppStorage("isLicenseVerified") private var isLicenseVerified: Bool = false

    @State private var wantsToEnterLicense = false
    @State private var statusMessage: LocalizedStringKey = ""
    @State private var isVerifying = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Título
            Text("preferences_license_title")
                .font(.title2)
                .fontWeight(.semibold)

            // Status atual
            HStack {
                Image(systemName: isLicenseVerified ? "checkmark.seal.fill" : "lock.fill")
                    .foregroundColor(isLicenseVerified ? .green : .gray)

                Text(isLicenseVerified ? "license_status_pro" : "license_status_free")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Botão de upgrade
            Button(action: {
                // Abrirá página externa ou futuro modal
                if let url = URL(string: "https://airclipboard.app/pro") {
                    NSWorkspace.shared.open(url)
                }
            }) {
                Text("license_upgrade_button")
                    .fontWeight(.medium)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(Color.accentColor.opacity(0.15))
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)

            // Checkbox para ativar chave manualmente
            Toggle("license_already_have", isOn: $wantsToEnterLicense)
                .toggleStyle(.checkbox)

            // Campos de ativação
            if wantsToEnterLicense {
                VStack(spacing: 12) {
                    TextField(LocalizedStringKey("license_email_placeholder"), text: $licenseEmail)
                        .textFieldStyle(.roundedBorder)

                    SecureField(LocalizedStringKey("license_key_placeholder"), text: $licenseKey)
                        .textFieldStyle(.roundedBorder)

                    HStack {
                        Button(action: verifyLicense) {
                            if isVerifying {
                                ProgressView().scaleEffect(0.3)
                            } else {
                                Text("license_verify_button")
                            }
                        }
                        .disabled(licenseEmail.isEmpty || licenseKey.isEmpty)

                        Spacer()

                        Text(statusMessage)
                            .font(.caption)
                            .foregroundColor(isLicenseVerified ? .green : .secondary)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeInOut(duration: 0.25), value: wantsToEnterLicense)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            statusMessage = isLicenseVerified
                ? "license_verified_message"
                : "license_not_verified_message"
            if isLicenseVerified && AppEnvironment.shared.licenseStatus == .free {
                    AppEnvironment.shared.updateLicenseStatus(.pro_lifetime)
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func verifyLicense() {
        isVerifying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            if licenseEmail.contains("@") && licenseKey.count >= 8 {
                isLicenseVerified = true
                statusMessage = "license_verified_message"
                AppEnvironment.shared.updateLicenseStatus(.pro_lifetime)
            } else {
                isLicenseVerified = false
                statusMessage = "license_invalid_message"
                AppEnvironment.shared.updateLicenseStatus(.free)
            }
            isVerifying = false
        }
    }
}
