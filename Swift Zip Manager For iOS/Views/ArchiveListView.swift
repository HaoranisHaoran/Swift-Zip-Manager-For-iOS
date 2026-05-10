//
//  ArchiveListView.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI
import UniformTypeIdentifiers

struct ArchiveListView: View {
    @ObservedObject var manager: ArchiveManager
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showingFilePicker = false
    @State private var showingExtractSheet = false
    
    var body: some View {
        NavigationStack {
            if manager.currentArchive == nil {
                VStack(spacing: 20) {
                    Image(systemName: "doc.zipper")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text(localized("no_archive"))
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Button(action: { showingFilePicker = true }) {
                        Label(localized("open_archive"), systemImage: "doc.badge.plus")
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                ArchiveDetailView(manager: manager, showingExtractSheet: $showingExtractSheet)
                    .environmentObject(languageManager)
            }
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.zip, .archive],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                manager.loadArchive(url)
            }
        }
        .sheet(isPresented: $showingExtractSheet) {
            ExtractArchiveSheet(manager: manager)
                .environmentObject(languageManager)
        }
    }
    
    private func localized(_ key: String) -> String {
        return languageManager.localizedString(key)
    }
}
