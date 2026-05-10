//
//  CreateArchiveView.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI
import UniformTypeIdentifiers

struct CreateArchiveView: View {
    @ObservedObject var manager: ArchiveManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedFiles: [URL] = []
    @State private var archiveName = ""
    @State private var selectedFormat = "zip"
    @State private var showingFilePicker = false
    @State private var destination: URL?
    @State private var showingDestinationPicker = false
    
    let formats = ["zip", "7z", "rar", "tar", "gz"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Archive Info") {
                    HStack {
                        TextField("Name", text: $archiveName)
                            .autocapitalization(.none)
                        Picker("", selection: $selectedFormat) {
                            ForEach(formats, id: \.self) { format in
                                Text(format.uppercased()).tag(format)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 80)
                    }
                }
                
                Section("Files") {
                    Button {
                        showingFilePicker = true
                    } label: {
                        Label("Add Files", systemImage: "plus.circle")
                            .foregroundColor(.blue)
                    }
                    
                    ForEach(selectedFiles, id: \.self) { file in
                        HStack {
                            Image(systemName: "doc")
                                .foregroundColor(.blue)
                            Text(file.lastPathComponent)
                                .lineLimit(1)
                            Spacer()
                            Button {
                                selectedFiles.removeAll { $0 == file }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section("Destination") {
                    Button {
                        showingDestinationPicker = true
                    } label: {
                        HStack {
                            Text("Save to")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(destination?.lastPathComponent ?? "Choose Folder")
                                .foregroundColor(destination == nil ? .secondary : .primary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("New Archive")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        if let dest = destination {
                            let name = archiveName.isEmpty ? "Archive" : archiveName
                            manager.createArchive(files: selectedFiles, format: selectedFormat, name: name, destination: dest)
                            dismiss()
                        }
                    }
                    .disabled(selectedFiles.isEmpty || destination == nil)
                    .buttonStyle(.borderedProminent)
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.data, .pdf, .image, .video, .audio, .plainText],
                allowsMultipleSelection: true
            ) { result in
                if case .success(let urls) = result {
                    selectedFiles.append(contentsOf: urls)
                }
            }
            .fileImporter(
                isPresented: $showingDestinationPicker,
                allowedContentTypes: [.folder],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result {
                    destination = urls.first
                }
            }
        }
    }
}
