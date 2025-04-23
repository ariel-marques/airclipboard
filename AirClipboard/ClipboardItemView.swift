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
        ZStack {
            contentArea
                .overlay(fileGroupLabel, alignment: .topLeading)
                .overlay(timestampOverlay.allowsHitTesting(false), alignment: .topTrailing)
                .overlay(pinOverlay, alignment: .bottomTrailing)
                .overlay(menuOverlay, alignment: .trailing)
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

    // MARK: - Seções

    private var contentArea: some View {
        HStack(alignment: .top) {
            contentView(for: item)
                .frame(maxWidth: 1100, minHeight: 50, alignment: .leading)
            Spacer()
        }
        .padding()
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
    }

    private var timestampOverlay: some View {
        Text(relativeDateFormatter.string(for: item.date) ?? "")
            .font(.caption2)
            .foregroundColor(.secondary)
            .padding(.top, 6)
            .padding(.trailing, 10)
    }

    private var fileGroupLabel: some View {
        Group {
            if case .fileGroup(let urls) = item.type {
                Text("\(urls.count) arquivos")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 6)
                    .padding(.leading, 10)
            }
        }
    }

    private var pinOverlay: some View {
        Group {
            if item.isPinned {
                Button(action: {
                    history.togglePin(for: item)
                }) {
                    Image(systemName: "pin")
                        .foregroundColor(.blue)
                        .padding(1)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 8)
                .padding(.bottom, 6)
            }
        }
    }

    private var menuOverlay: some View {
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
        .frame(width: 25)
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
    }

    // MARK: - Conteúdo

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
            .help(url.lastPathComponent)

        case .image(let data):
            if let nsImage = NSImage(data: data) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
            }

        case .fileGroup(let urls):
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    ForEach(urls.prefix(6), id: \.self) { url in
                        FileIconView(fileURL: url)
                            .frame(width: 40, height: 40)
                            .cornerRadius(2)
                            .help(url.lastPathComponent)
                    }

                    if urls.count > 6 {
                        Text("+\(urls.count - 6)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 1)
                            .help(urls.dropFirst(6).map { $0.lastPathComponent }.joined(separator: "\n"))
                    }
                }
                .padding(.leading, 4)
            }
        }
    }

    private var relativeDateFormatter: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }
}

#Preview {
    ContentView()
}
