//
//  HeaderView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 03/04/25.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("ΛirClipboard")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Spacer()
                .padding()

            Button {
                print("🔘 Preferências (HeaderView) clicado")
                AppDelegate.shared?.showPreferences()
            } label: {
                Image(systemName: "ellipsis.circle")
                    .symbolRenderingMode(.multicolor)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .buttonStyle(.plain)
            .help("Abrir preferências")
            .padding(.top, 8.0)
            .frame(maxWidth: 25, minHeight: 50, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.bottom, 9.0)
    }
}
#Preview {
    HeaderView()
}
