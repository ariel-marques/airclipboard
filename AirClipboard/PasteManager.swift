//
//  PasteManager.swift
//  AirClipboard
//
//  Created by Ariel Marques on 12/04/25.
//

import AppKit

class PasteManager {
    static let shared = PasteManager()

    private init() {}

    func copyToPasteboard(item: ClipboardItem) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()

        switch item.type {
        case .text(let value):
            pasteboard.setString(value, forType: .string)

        case .image(let data):
            // ✅ Se possível, converte a imagem em um arquivo temporário para funcionar no Finder
            if let tempURL = writeImageAsTempFile(data) {
                pasteboard.writeObjects([tempURL as NSURL])
            } else if let image = NSImage(data: data) {
                pasteboard.writeObjects([image])
            }

        case .file(let url):
            pasteboard.writeObjects([url as NSURL])

        case .fileGroup(let urls):
            let nsURLs = urls.map { $0 as NSURL }
            pasteboard.writeObjects(nsURLs)
        }

        print("📋 Conteúdo copiado para a área de transferência")
    }

    func performPaste() {
        PasteStrategy.performPaste() // ⌘V simulado
    }

    // 🔧 Gera um arquivo .png temporário para que a imagem possa ser colada como arquivo no Finder
    private func writeImageAsTempFile(_ data: Data) -> URL? {
        let filename = "ɅirClipboard_Image_\(UUID().uuidString).png"
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)

        do {
            try data.write(to: tempURL)
            return tempURL
        } catch {
            print("⚠️ Erro ao salvar imagem temporária: \(error)")
            return nil
        }
    }
}
