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
            Text("preferences_license_title")
                .font(.title2)
                .fontWeight(.semibold)

            Toggle("license_already_have", isOn: $wantsToEnterLicense)
                .toggleStyle(.checkbox)

            if wantsToEnterLicense {
                VStack(spacing: 12) {
                    TextField(LocalizedStringKey("license_email_placeholder"), text: $licenseEmail)
                        .textFieldStyle(.roundedBorder)

                    SecureField(LocalizedStringKey("license_key_placeholder"), text: $licenseKey)
                        .textFieldStyle(.roundedBorder)

                    HStack {
                        Button(action: verifyLicense) {
                            if isVerifying {
                                ProgressView().scaleEffect(0.8)
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func verifyLicense() {
        isVerifying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            if licenseEmail.contains("@") && licenseKey.count >= 8 {
                isLicenseVerified = true
                statusMessage = "license_verified_message"
            } else {
                isLicenseVerified = false
                statusMessage = "license_invalid_message"
            }
            isVerifying = false
        }
    }
}
