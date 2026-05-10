//
//  ContentView.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var languageManager = LanguageManager()
    @StateObject private var archiveManager = ArchiveManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FileBrowserView(manager: archiveManager)
                .environmentObject(languageManager)
                .tabItem {
                    Label(languageManager.localizedString("files"), systemImage: "folder")
                }
                .tag(0)
            
            ArchiveListView(manager: archiveManager)
                .environmentObject(languageManager)
                .tabItem {
                    Label(languageManager.localizedString("archives"), systemImage: "doc.zipper")
                }
                .tag(1)
            
            SettingsView()
                .environmentObject(languageManager)
                .tabItem {
                    Label(languageManager.localizedString("settings"), systemImage: "gear")
                }
                .tag(2)
        }
        .environmentObject(appState)
        .environmentObject(languageManager)
        .alert(archiveManager.error ?? languageManager.localizedString("done"), isPresented: $archiveManager.showAlert) {
            Button(languageManager.localizedString("ok")) { }
        }
        .sheet(isPresented: $appState.showNewArchive) {
            NewArchiveSheet(manager: archiveManager)
                .environmentObject(languageManager)
        }
    }
}
