//
//  FileIconView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 03/04/25.
//

import SwiftUI
import UniformTypeIdentifiers
import QuickLookThumbnailing

struct FileIconView: View {
    let fileURL: URL
    @State private var thumbnailImage: NSImage?

    private let imageExtensions = ["png", "jpg", "jpeg", "gif", "heic"]

    var body: some View {
        Group {
            if let image = thumbnailImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } else if isImage(fileURL) {
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
        .onAppear {
            if !isImage(fileURL) {
                generateThumbnail(for: fileURL)
            }
        }
    }

    private func isImage(_ url: URL) -> Bool {
        imageExtensions.contains(url.pathExtension.lowercased())
    }

    private func iconForFileType(_ type: String) -> String {
        switch type {
        case "pdf": return "doc.richtext"
        case "txt", "md": return "text.alignleft"
        case "pages", "docx", "doc": return "doc"
        default: return "doc"
        }
    }

    private func generateThumbnail(for url: URL) {
        let size = CGSize(width: 64, height: 64)
        let scale = NSScreen.main?.backingScaleFactor ?? 2.0

        let request = QLThumbnailGenerator.Request(
            fileAt: url,
            size: size,
            scale: scale,
            representationTypes: .all
        )

        QLThumbnailGenerator.shared.generateBestRepresentation(for: request) { thumbnail, error in
            if let cgImage = thumbnail?.cgImage {
                DispatchQueue.main.async {
                    self.thumbnailImage = NSImage(cgImage: cgImage, size: size)
                }
            } else if let error = error {
                print("❌ Falha ao gerar thumbnail para \(url.lastPathComponent): \(error.localizedDescription)")
            }
        }
    }
}
