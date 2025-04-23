//
//  SearchBar.swift
//  AirClipboard
//
//  Created by Ariel Marques on 03/04/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(LocalizedStringKey("search_placeholder"), text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .textFieldStyle(.automatic)
                .disableAutocorrection(true)
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.quaternary.opacity(0.2))
        )
        .padding(.horizontal)
        .padding(.bottom,8.0)
    }
}
