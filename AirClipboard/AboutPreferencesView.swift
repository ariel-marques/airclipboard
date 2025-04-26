//
//  AboutPreferencesView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 21/04/25.
//

import SwiftUI

struct AboutPreferencesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Cabeçalho com ícone e nome
            HStack(alignment: .center, spacing: 12) {
                Image(nsImage: NSApplication.shared.applicationIconImage)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 4) {
                    Text("ɅirClipboard")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("version_label") // Versão 1.0.0
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            // Descrição
            Text("about_description")
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            // Links úteis
            VStack(alignment: .leading, spacing: 10) {
                Link("official_site", destination: URL(string: "https://ariel.works")!)
                Link("privacy_policy", destination: URL(string: "https://ariel.works/airclipboard/privacy")!)
                Link("send_feedback", destination: URL(string: "mailto:airclipboardapp@gmail.com")!)
            }
            .font(.subheadline)

            Divider()

            // Créditos
            VStack(alignment: .leading, spacing: 4) {
                Text("credits_title")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text("credit_development")
                Text("credit_icons")
                Text("credit_community")
                Text("credit_special_thanks")
            }
            .font(.footnote)
            .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
