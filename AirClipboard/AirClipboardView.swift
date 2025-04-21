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
                return true // Continua exibindo arquivos e imagens mesmo que a busca esteja ativa
            }
        }
    }

    var body: some View {
        print("🧩 AirClipboardView foi renderizada")

        return VStack(spacing: 0) {
            HeaderView()
            SearchBar(text: $searchText)

            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        Spacer(minLength: 8) // ✅ respiro no topo
                        
                        ForEach(filteredItems) { item in
                            ClipboardItemView(item: item)
                                .id(item.id)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                }
                .onChange(of: history.lastInsertedID) { id in
                    guard let id = id else { return }

                    // Garantir que o scroll ocorra após ordenação completa
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut) {
                            scrollProxy.scrollTo(id, anchor: .top)
                        }
                    }
                }
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
