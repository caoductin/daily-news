//
//  LanguageSettingView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 14/6/25.
//

import SwiftUI

struct LanguageSettingView: View {
    @StateObject var viewModel = LanguageSettingViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            List {
                ForEach(viewModel.filteredLanguages) { lang in
                    HStack {
                        Text("\(lang.flag) \(lang.displayName)")
                            .font(.system(size: 18, weight: .medium))
                        Spacer()
                        if lang == viewModel.selectedLang {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.requestSelect(lang: lang)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .background(Color(.systemGroupedBackground))
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "You want to change language to \(viewModel.pendingLang?.displayName ?? "")?",
            isPresented: $viewModel.showConfirmDialog,
            titleVisibility: .visible
        ) {
            Button("Change", role: .destructive) {
                viewModel.confirmChange()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    NavigationStack {
        LanguageSettingView()
    }
}

enum SupportedLang: String, CaseIterable, Identifiable {
    case vietnamese = "vi"
    case english = "en"
    case japanese = "ja"
    case korean = "ko"
    case french = "fr"
    case chinese = "zh"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .vietnamese: return "Vietnamese"
        case .english: return "English"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        case .french: return "French"
        case .chinese: return "Chinese"
        }
    }
    
    var flag: String {
        switch self {
        case .vietnamese: return "🇻🇳"
        case .english: return "🇺🇸"
        case .japanese: return "🇯🇵"
        case .korean: return "🇰🇷"
        case .french: return "🇫🇷"
        case .chinese: return "🇨🇳"
        }
    }
    
    static func from(lang: String) -> SupportedLang? {
        return SupportedLang.allCases.first { $0.rawValue == lang }
    }
    
}
