//
//  ClipboardStorage.swift
//  AirClipboard
//
//  Created by Ariel Marques on 02/04/25.
//

import Foundation

class ClipboardStorage {
    private let fileURL: URL

    init(filename: String = "clipboard_history.json") {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = documentDirectory.appendingPathComponent(filename)
    }

    func saveHistory(_ history: [ClipboardItem]) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(history)
                try data.write(to: self.fileURL)
            } catch {
                print("❌ Erro ao salvar histórico: \(error.localizedDescription)")
            }
        }
    }

    func loadHistory() -> [ClipboardItem] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([ClipboardItem].self, from: data)
        } catch {
            print("⚠️ Nenhum histórico encontrado ou erro ao carregar: \(error.localizedDescription)")
            return []
        }
    }
}
