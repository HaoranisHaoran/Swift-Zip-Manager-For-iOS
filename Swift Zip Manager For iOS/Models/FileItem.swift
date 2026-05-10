//
//  FileItem.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import Foundation
import SwiftUI

struct FileItem: Identifiable {
    let id = UUID()
    let url: URL
    let name: String
    let isDirectory: Bool
    let isArchive: Bool
    let size: Int64?
    let modificationDate: Date?
    
    var sizeFormatted: String {
        guard let size = size else { return "--" }
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
}
