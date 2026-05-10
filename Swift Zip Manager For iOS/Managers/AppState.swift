//
//  AppState.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var showNewArchive = false
    @Published var showSettings = false
    @Published var isProcessing = false
    @Published var errorMessage: String? = nil
}
