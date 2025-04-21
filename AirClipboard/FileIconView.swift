//
//  FileIconView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 03/04/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileIconView: View {
    let fileURL: URL

    private let imageExtensions = ["png", "jpg", "jpeg", "gif", "heic"]

    var body: some View {
        if isImage(fileURL) {
            ImageThumbnailView(fileURL: fileURL)
        } else {
            Image(systemName: iconForFileType(fileURL.pathExtension.lowercased()))
                .resizable()
                .frame(width: 24, height: 24)
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private func isImage(_ url: URL) -> Bool {
        imageExtensions.contains(url.pathExtension.lowercased())
    }

    private func iconForFileType(_ type: String) -> String {
        switch type {
        case "pdf": return "doc.richtext"
        case "txt", "md": return "text.alignleft"
        case "pages", "docx": return "doc"
        default: return "doc" // fallback menos "erro visual"
        }
    }
}
