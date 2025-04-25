//
//  ClipboardHistory.swift
//  AirClipboard
//
//  Created by Ariel Marques on 02/04/25.
//

import Foundation
import SwiftUI

class ClipboardHistory: ObservableObject {
    @Published var lastInsertedID: UUID?
    @Published var history: [ClipboardItem] = []
    private let storage = ClipboardStorage()

    @AppStorage("historyLimit") private var historyLimit: Int = 50

    init() {
        self.history = storage.loadHistory()
        sortByPinnedAndDate()
    }

    func addItem(_ item: ClipboardItem) {
        // 🔍 Remove duplicatas antes de adicionar (preservando pins)
        history.removeAll(where: { $0.type == item.type && !$0.isPinned })

        history.insert(item, at: 0)
        lastInsertedID = item.id

        sortByPinnedAndDate()

        // 🧹 Limita histórico aos X itens mais recentes (sem contar fixados)
        let pinned = history.filter { $0.isPinned }
        let unpinned = history.filter { !$0.isPinned }
        let trimmed = Array(unpinned.prefix(historyLimit))

        self.history = pinned + trimmed
        storage.saveHistory(history)
    }

    func togglePin(for item: ClipboardItem) {
        if let index = history.firstIndex(where: { $0.id == item.id }) {
            history[index].isPinned.toggle()
            sortByPinnedAndDate()
            lastInsertedID = history[index].id // 👈 Atualiza o ID após fixar/desafixar
            storage.saveHistory(history)
        }
    }
    func clearHistory() {
        history.removeAll()
        storage.saveHistory(history)
    }

    func delete(item: ClipboardItem) {
        history.removeAll { $0.id == item.id }
        storage.saveHistory(history)
    }

    private func sortByPinnedAndDate() {
        history.sort {
            if $0.isPinned == $1.isPinned {
                return $0.date > $1.date
            }
            return $0.isPinned && !$1.isPinned
        }
    }
}
