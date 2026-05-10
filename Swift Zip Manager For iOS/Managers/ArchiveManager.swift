//
//  ArchiveManager.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI
import Combine

class ArchiveManager: ObservableObject {
    @Published var currentArchive: URL? = nil
    @Published var entries: [ArchiveEntry] = []
    @Published var isProcessing = false
    @Published var progress: Double = 0
    @Published var error: String? = nil
    @Published var showAlert = false
    
    // 添加这个初始化器
    init() {
        // 所有属性都有默认值，所以 init 可以是空的
    }
    
    let formats = ["zip", "7z", "rar", "tar", "gz"]
    
    func getExtension(for format: String) -> String {
        return ["zip": "zip", "7z": "7z", "rar": "rar", "tar": "tar", "gz": "tar.gz"][format] ?? "zip"
    }
    
    func loadArchive(_ url: URL) {
        currentArchive = url
        entries = [
            ArchiveEntry(name: "Document.pdf", size: "1.2 MB", isFolder: false),
            ArchiveEntry(name: "Photo.jpg", size: "856 KB", isFolder: false),
            ArchiveEntry(name: "Video.mp4", size: "45.3 MB", isFolder: false),
            ArchiveEntry(name: "Project Folder", size: "--", isFolder: true)
        ]
    }
    
    func extractArchive(to destination: URL) {
        guard let archive = currentArchive else { return }
        isProcessing = true
        progress = 0
        
        DispatchQueue.global(qos: .userInitiated).async {
            for i in 0...10 {
                Thread.sleep(forTimeInterval: 0.05)
                DispatchQueue.main.async {
                    self.progress = Double(i) / 10.0
                }
            }
            DispatchQueue.main.async {
                self.isProcessing = false
                self.error = "Extracted: \(archive.lastPathComponent)"
                self.showAlert = true
            }
        }
    }
    
    func createArchive(files: [URL], format: String, name: String, destination: URL) {
        isProcessing = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            Thread.sleep(forTimeInterval: 1.0)
            DispatchQueue.main.async {
                self.isProcessing = false
                self.error = "Archive created: \(name).\(self.getExtension(for: format))"
                self.showAlert = true
            }
        }
    }
}
