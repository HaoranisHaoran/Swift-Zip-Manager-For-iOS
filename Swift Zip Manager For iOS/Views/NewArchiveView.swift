//
//  NewArchiveView.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI
import UniformTypeIdentifiers

struct NewArchiveSheet: View {
    @ObservedObject var manager: ArchiveManager
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedFiles: [URL] = []
    @State private var archiveName = ""
    @State private var selectedFormat = "zip"
    @State private var showingFilePicker = false
    
    let formats = ["zip", "7z", "rar"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(localized("archive_info")) {
                    TextField(localized("name"), text: $archiveName)
                    Picker(localized("format"), selection: $selectedFormat) {
                        ForEach(formats, id: \.self) { format in
                            Text(format.uppercased()).tag(format)
                        }
                    }
                }
                
                Section(localized("files")) {
                    Button(localized("add_files")) {
                        showingFilePicker = true
                    }
                    
                    ForEach(selectedFiles, id: \.self) { file in
                        HStack {
                            Text(file.lastPathComponent)
                            Spacer()
                            Button {
                                selectedFiles.removeAll { $0 == file }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle(localized("new_archive"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(localized("cancel")) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(localized("create")) {
                        if let dest = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            let name = archiveName.isEmpty ? "Archive" : archiveName
                            manager.createArchive(files: selectedFiles, format: selectedFormat, name: name, destination: dest)
                            dismiss()
                        }
                    }
                    .disabled(selectedFiles.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.data, .image, .pdf],
                allowsMultipleSelection: true
            ) { result in
                if case .success(let urls) = result {
                    selectedFiles.append(contentsOf: urls)
                }
            }
        }
    }
    
    private func localized(_ key: String) -> String {
        return languageManager.localizedString(key)
    }
}
