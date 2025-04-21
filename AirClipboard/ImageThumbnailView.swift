//
//  ImageThumbnailView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 03/04/25.
//

import SwiftUI

struct ImageThumbnailView: View {
    let fileURL: URL

    var body: some View {
        if let image = NSImage(contentsOf: fileURL) {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 0.5)
                )
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .frame(width: 40, height: 40)
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
