//
//  ArchiveEntry.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import Foundation

struct ArchiveEntry: Identifiable {
    let id = UUID()
    let name: String
    let size: String
    let isFolder: Bool
}
