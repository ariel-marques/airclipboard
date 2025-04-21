//
//  ClipboardItemView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 02/04/25.
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct ClipboardItemView: View {
    @AppStorage("playClickSound") private var playClickSound: Bool = true
    @EnvironmentObject var history: ClipboardHistory
    var item: ClipboardItem
    @State private var isHovering = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HStack(alignment: .top) {
                contentView(for: item)
                    .frame(maxWidth: 1100, minHeight: 50, alignment: .leading)
                Spacer()
            }
            .padding()
            .frame(maxHeight: 100)
            .contentShape(Rectangle())
            .onTapGesture {
                if playClickSound {
                    NSSound(named: "Blow")?.play()
                }
                PasteManager.shared.copyToPasteboard(item: item)
                NSApp.hide(nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    PasteManager.shared.performPaste()
                }
            }

            if item.isPinned {
                Button(action: {
                    history.togglePin(for: item)
                }) {
                    Image(systemName: "pin")
                        .foregroundColor(.blue)
                        .padding(6)
                        .transition(.scale)
                }
                .buttonStyle(.plain)
            }

            Menu {
                Button("Copiar novamente") {
                    PasteManager.shared.copyToPasteboard(item: item)
                }

                Button(item.isPinned ? "Desafixar" : "Fixar no topo") {
                    history.togglePin(for: item)
                }

                Button("Excluir") {
                    history.delete(item: item)
                }
            } label: {
                Image(systemName: "ellipsis")
                    .symbolRenderingMode(.multicolor)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .padding(8)
            }
            .padding(.bottom, 80.0)
            .frame(width: 25.0, height: 0.0)
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isHovering ? Color.accentColor : Color.clear, lineWidth: 0.5)
                        .animation(.easeInOut(duration: 0.3), value: isHovering)
                )
        )
        .onHover { hovering in
            isHovering = hovering
        }
        .padding(.horizontal, 7)
        .listRowSeparator(.hidden)
    }

    @ViewBuilder
    private func contentView(for item: ClipboardItem) -> some View {
        switch item.type {
        case .text(let value):
            let formattedValue = value.replacingOccurrences(of: "\\s{2,}", with: " ", options: .regularExpression)
            HStack {
                Text(formattedValue)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .truncationMode(.tail)
                    .frame(maxWidth: 335, alignment: .leading)
                Spacer()
            }

        case .file(let url):
            VStack(spacing: 4) {
                FileIconView(fileURL: url)
                    .frame(width: 32, height: 32)
                Text(url.lastPathComponent)
                    .font(.caption2)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(width: 70)
            }

        case .image(let data):
            if let nsImage = NSImage(data: data) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
            }
            
        case .fileGroup(let urls):
            VStack(alignment: .leading, spacing: 8) {
                Text("\(urls.count) arquivos")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 10) {
                    ForEach(urls.prefix(6), id: \.self) { url in
                        FileIconView(fileURL: url)
                            .frame(width: 40, height: 40)
                            .cornerRadius(2)
                            .help(url.lastPathComponent) // ✅ Tooltip individual
                    }

                    if urls.count > 6 {
                        Text("+\(urls.count - 6)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)
                            .help(urls.dropFirst(6).map { $0.lastPathComponent }.joined(separator: "\n")) // ✅ Tooltip com os extras
                    }
                }
                .padding(.leading, 4)
            }
        }
    }
}

#Preview {
    ContentView()
}
