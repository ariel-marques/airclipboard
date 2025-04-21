//
//  ClipboardMonitor.swift
//  AirClipboard
//
//  Created by Ariel Marques on 02/04/25.
//

import AppKit
import Foundation

class ClipboardMonitor {
    private var timer: Timer?
    private weak var history: ClipboardHistory?

    init(history: ClipboardHistory) {
        self.history = history
    }

    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkClipboard()
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    private func checkClipboard() {
        guard let history = history else { return }
        let pasteboard = NSPasteboard.general

        // 1. Verifica múltiplos arquivos
        if let items = pasteboard.pasteboardItems {
            let fileURLs: [URL] = items.compactMap { item in
                if let fileURLString = item.string(forType: .fileURL),
                   let fileURL = URL(string: fileURLString) {
                    return fileURL
                }
                return nil
            }

            if !fileURLs.isEmpty {
                if fileURLs.count == 1 {
                    let singleFile = ClipboardItem(type: .file(fileURLs[0]))
                    appendIfNew(singleFile, to: history)
                } else {
                    let group = ClipboardItem(type: .fileGroup(fileURLs))
                    appendIfNew(group, to: history)
                }
                return
            }
        }

        // 2. Verifica texto
        if let text = pasteboard.string(forType: .string) {
            let item = ClipboardItem(type: .text(text))
            appendIfNew(item, to: history)
            return
        }

        // 3. Verifica imagem
        if let imageData = pasteboard.data(forType: .tiff) {
            let item = ClipboardItem(type: .image(imageData))
            appendIfNew(item, to: history)
        }
    }

    private func appendIfNew(_ item: ClipboardItem, to history: ClipboardHistory) {
        if !history.history.contains(where: { $0.isDuplicate(of: item) }) {
            history.addItem(item)
        }
    }
}
