//
//  SearchBar.swift
//  AirClipboard
//
//  Created by Ariel Marques on 03/04/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(LocalizedStringKey("search_placeholder"), text: $text)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .focused($isFocused)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                    isFocused = true
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.system(size: 14))
                }
                .buttonStyle(.plain)
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut(duration: 0.2), value: text)
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.quaternary.opacity(0.2))
        )
        .padding(.horizontal)
        .padding(.bottom, 8.0)
    }
}
