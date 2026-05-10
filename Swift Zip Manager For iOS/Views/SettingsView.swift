//
//  SettingsView.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationStack {
            Form {
                Section(localized("general")) {
                    HStack {
                        Text(localized("language"))
                        Spacer()
                        Picker("", selection: $languageManager.currentLanguage) {
                            ForEach(Array(languageManager.supportedLanguages.keys.sorted()), id: \.self) { code in
                                Text(languageManager.supportedLanguages[code] ?? code).tag(code)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 130)
                        .onChange(of: languageManager.currentLanguage) { newValue in
                            languageManager.setLanguage(newValue)
                        }
                    }
                }
                
                Section(localized("about")) {
                    HStack {
                        Text(localized("version"))
                        Spacer()
                        Text("0.0.1-Demo")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(localized("settings"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func localized(_ key: String) -> String {
        return languageManager.localizedString(key)
    }
}
