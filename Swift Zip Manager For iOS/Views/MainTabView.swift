//
//  MainTabView.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var archiveManager = ArchiveManager()
    @State private var selectedTab: Tab = .files
    
    enum Tab {
        case files, archives, settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FileBrowserView(manager: archiveManager)
                .tabItem {
                    Label("Files", systemImage: "folder")
                }
                .tag(Tab.files)
            
            ArchiveListView(manager: archiveManager)
                .tabItem {
                    Label("Archives", systemImage: "doc.zipper")
                }
                .tag(Tab.archives)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .tint(.blue)
        .alert(archiveManager.error ?? "Done", isPresented: $archiveManager.showAlert) {
            Button("OK") { }
        }
        .sheet(isPresented: $appState.showNewArchive) {
            CreateArchiveView(manager: archiveManager)
        }
    }
}
