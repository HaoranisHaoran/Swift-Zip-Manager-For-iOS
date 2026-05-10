//
//  FileBrowserView.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileBrowserView: View {
    @ObservedObject var manager: ArchiveManager
    @EnvironmentObject var languageManager: LanguageManager
    @State private var currentDirectory: URL? = nil
    @State private var items: [FileItem] = []
    @State private var isLoading = false
    @State private var showingFilePicker = false
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else if items.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "folder")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text(localized("empty_folder"))
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List(items) { item in
                        HStack {
                            Image(systemName: item.isDirectory ? "folder" : "doc")
                                .foregroundColor(item.isDirectory ? .yellow : .blue)
                            Text(item.name)
                            Spacer()
                            if !item.isDirectory {
                                Text(item.sizeFormatted)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if item.isDirectory {
                                currentDirectory = item.url
                                loadContents()
                            } else if item.isArchive {
                                manager.loadArchive(item.url)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle(currentDirectory?.lastPathComponent ?? localized("files"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if currentDirectory?.path != documentsDirectory.path && currentDirectory != nil {
                        Button(action: goUp) {
                            Image(systemName: "chevron.up")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingFilePicker = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.data, .image, .pdf, .text],
                allowsMultipleSelection: true
            ) { result in
                if case .success(let urls) = result {
                    for url in urls {
                        importFile(url)
                    }
                    loadContents()
                }
            }
            .onAppear {
                if currentDirectory == nil {
                    currentDirectory = documentsDirectory
                    loadContents()
                }
            }
            .onChange(of: currentDirectory) { _ in
                loadContents()
            }
        }
    }
    
    private func localized(_ key: String) -> String {
        return languageManager.localizedString(key)
    }
    
    private func loadContents() {
        guard let dir = currentDirectory else { return }
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let loadedItems = loadDirectoryContents(dir)
            DispatchQueue.main.async {
                items = loadedItems
                isLoading = false
            }
        }
    }
    
    private func loadDirectoryContents(_ url: URL) -> [FileItem] {
        var fileItems: [FileItem] = []
        let fm = FileManager.default
        
        guard let contents = try? fm.contentsOfDirectory(at: url, includingPropertiesForKeys: [.isDirectoryKey]) else {
            return fileItems
        }
        
        for url in contents {
            let isDirectory = (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
            let isArchive = !isDirectory && ["zip", "7z", "rar", "tar"].contains(url.pathExtension.lowercased())
            let size = isDirectory ? nil : (try? fm.attributesOfItem(atPath: url.path)[.size] as? Int64)
            
            fileItems.append(FileItem(
                url: url,
                name: url.lastPathComponent,
                isDirectory: isDirectory,
                isArchive: isArchive,
                size: size,
                modificationDate: nil
            ))
        }
        
        fileItems.sort { a, b in
            if a.isDirectory != b.isDirectory { return a.isDirectory && !b.isDirectory }
            return a.name.localizedStandardCompare(b.name) == .orderedAscending
        }
        
        return fileItems
    }
    
    private func goUp() {
        if let dir = currentDirectory?.deletingLastPathComponent() {
            currentDirectory = dir
        }
    }
    
    private func importFile(_ sourceURL: URL) {
        guard let destination = currentDirectory else { return }
        let destinationURL = destination.appendingPathComponent(sourceURL.lastPathComponent)
        guard !FileManager.default.fileExists(atPath: destinationURL.path) else { return }
        try? FileManager.default.copyItem(at: sourceURL, to: destinationURL)
    }
}
