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

                    Text("Versão 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            // Descrição
            Text("O ɅirClipboard é um gerenciador de área de transferência elegante e eficiente para macOS, com foco em produtividade e acessibilidade.")
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            // Links úteis
            VStack(alignment: .leading, spacing: 10) {
                Link("🌐 Site oficial", destination: URL(string: "https://airclipboard.app")!)
                Link("🔐 Política de Privacidade", destination: URL(string: "https://airclipboard.app/privacidade")!)
                Link("💬 Enviar feedback", destination: URL(string: "mailto:suporte@airclipboard.app")!)
            }
            .font(.subheadline)

            Divider()

            // Créditos
            VStack(alignment: .leading, spacing: 4) {
                Text("Créditos")
                    .font(.headline)
                    .foregroundColor(Color.secondary)

                Text("Desenvolvimento, design e direção por Ariel Marques.")
                Text("Ícones por SF Symbols e QuickLook.")
                Text("Obrigado à comunidade Swift e aos testes de usuários do app.")
                Text("Agradecimento especial: Noa Chatfield.")

            }
            .font(.footnote)
            .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AboutPreferencesView()
}
