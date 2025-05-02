//
//  ClipboardItem.swift
//  AirClipboard
//
//  Created by Ariel Marques on 02/04/25.
//

import AppKit
import Foundation

struct ClipboardItem: Identifiable, Codable, Equatable {
    let id: UUID
    let type: ClipboardItemType
    let date: Date
    var isPinned: Bool = false

    init(type: ClipboardItemType, date: Date = Date(), isPinned: Bool = false) {
        self.id = UUID()
        self.type = type
        self.date = date
        self.isPinned = isPinned
    }
}

extension ClipboardItem {
    func isDuplicate(of other: ClipboardItem) -> Bool {
        switch (self.type, other.type) {
        case (.text(let a), .text(let b)):
            return a == b
        case (.file(let a), .file(let b)):
            return a == b
        case (.image(let a), .image(let b)):
            return a == b
        case (.fileGroup(let a), .fileGroup(let b)):
            return Set(a) == Set(b)
        default:
            return false
        }
    }
}

enum ClipboardItemType: Codable, Equatable {
    case text(String)
    case file(URL)
    case fileGroup([URL])
    case image(Data)

    enum CodingKeys: String, CodingKey {
        case type, value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)

        switch typeString {
        case "text":
            let value = try container.decode(String.self, forKey: .value)
            self = .text(value)
        case "file":
            let value = try container.decode(URL.self, forKey: .value)
            self = .file(value)
        case "fileGroup":
            let value = try container.decode([URL].self, forKey: .value)
            self = .fileGroup(value)
        case "image":
            let value = try container.decode(Data.self, forKey: .value)
            self = .image(value)
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Tipo desconhecido: \(typeString)"
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .text(let value):
            try container.encode("text", forKey: .type)
            try container.encode(value, forKey: .value)
        case .file(let value):
            try container.encode("file", forKey: .type)
            try container.encode(value, forKey: .value)
        case .fileGroup(let value):
            try container.encode("fileGroup", forKey: .type)
            try container.encode(value, forKey: .value)
        case .image(let value):
            try container.encode("image", forKey: .type)
            try container.encode(value, forKey: .value)
        }
    }
}

extension ClipboardItemType {
    var faviconURL: URL? {
        guard case .text(let value) = self,
              let url = URL(string: value),
              url.scheme?.hasPrefix("http") == true,
              let host = url.host else {
            return nil
        }

        return URL(string: "https://\(host)/favicon.ico")
    }
}
