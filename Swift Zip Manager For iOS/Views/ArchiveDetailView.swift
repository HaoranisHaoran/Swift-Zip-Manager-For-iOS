//
//  ArchiveDetailView.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI

struct ArchiveDetailView: View {
    @ObservedObject var manager: ArchiveManager
    @Binding var showingExtractSheet: Bool
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "doc.zipper")
                    .foregroundColor(.blue)
                Text(manager.currentArchive?.lastPathComponent ?? "")
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text("\(manager.entries.count) \(localized("items"))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            
            if manager.isProcessing {
                VStack(spacing: 8) {
                    ProgressView(value: manager.progress)
                        .progressViewStyle(.linear)
                    Text(localized("extracting"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            
            List(manager.entries) { entry in
                HStack {
                    Image(systemName: entry.isFolder ? "folder" : "doc")
                        .foregroundColor(entry.isFolder ? .yellow : .blue)
                    Text(entry.name)
                    Spacer()
                    if !entry.isFolder {
                        Text(entry.size)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle(localized("archives"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingExtractSheet = true }) {
                    Label(localized("extract_all"), systemImage: "archivebox")
                }
            }
        }
    }
    
    private func localized(_ key: String) -> String {
        return languageManager.localizedString(key)
    }
}
