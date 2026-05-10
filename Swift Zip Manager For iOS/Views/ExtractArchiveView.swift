//
//  ExtractArchiveSheet.swift
//  Swift Zip Manager For iOS
//
//  Created by Haoran on 2026/5/10.
//

import SwiftUI

struct ExtractArchiveSheet: View {
    @ObservedObject var manager: ArchiveManager
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button(action: {
                        let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        manager.extractArchive(to: destination)
                        dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text(extractButtonText)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(localized("extract"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(localized("cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var extractButtonText: String {
        let lang = languageManager.currentLanguage
        if lang.hasPrefix("zh") {
            return "解压到文档"
        } else if lang.hasPrefix("ja") {
            return "書類に解凍"
        } else if lang.hasPrefix("ko") {
            return "문서에 압축 풀기"
        } else if lang.hasPrefix("fr") {
            return "Extraire vers Documents"
        } else if lang.hasPrefix("de") {
            return "Nach Dokumente entpacken"
        } else if lang.hasPrefix("es") {
            return "Extraer a Documentos"
        } else if lang.hasPrefix("it") {
            return "Estrai in Documenti"
        } else if lang.hasPrefix("pt") {
            return "Extrair para Documentos"
        } else if lang.hasPrefix("ru") {
            return "Извлечь в Документы"
        } else if lang.hasPrefix("ar") {
            return "استخراج إلى المستندات"
        } else if lang.hasPrefix("tr") {
            return "Belgelere Çıkar"
        } else if lang.hasPrefix("vi") {
            return "Giải nén vào Tài liệu"
        } else {
            return "Extract to Documents"
        }
    }
    
    private func localized(_ key: String) -> String {
        return languageManager.localizedString(key)
    }
}
