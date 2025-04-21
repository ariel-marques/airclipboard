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

    @State private var statusMessage: String = ""
    @State private var isVerifying = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Licença")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(spacing: 12) {
                TextField("E-mail", text: $licenseEmail)
                    .textFieldStyle(.roundedBorder)

                SecureField("Chave de Licença", text: $licenseKey)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Button(action: verifyLicense) {
                        if isVerifying {
                            ProgressView().scaleEffect(0.8)
                        } else {
                            Text("Verificar Licença")
                        }
                    }
                    .disabled(licenseEmail.isEmpty || licenseKey.isEmpty)

                    Spacer()

                    Text(statusMessage)
                        .font(.caption)
                        .foregroundColor(isLicenseVerified ? .green : .secondary)
                }
            }

            Spacer()
        }
        .padding()
        .onAppear {
            statusMessage = isLicenseVerified
                ? "✅ Licença verificada com sucesso."
                : "🔒 Licença não verificada."
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func verifyLicense() {
        isVerifying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            if licenseEmail.contains("@") && licenseKey.count >= 8 {
                isLicenseVerified = true
                statusMessage = "✅ Licença verificada com sucesso."
            } else {
                isLicenseVerified = false
                statusMessage = "🚫 Licença inválida. Verifique os dados."
            }
            isVerifying = false
        }
    }
}
