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
            Text("Chọn ngôn ngữ")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            TextField("Tìm kiếm ngôn ngữ...", text: $viewModel.searchText)
                .font(.title3)
                .textFieldStyle(.outline())
                .padding(.horizontal)

            List {
                Section {
                    ForEach(viewModel.filteredLanguages) { lang in
                        HStack {
                            Text("\(lang.flag) \(lang.displayName)")
                                .font(.system(size: 17, weight: .medium))
                            Spacer()
                            if lang == viewModel.selectedLang {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 10)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.requestSelect(lang: lang)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .padding()
            .scrollContentBackground(.hidden)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Ngôn ngữ")
        .confirmationDialog(
            "Bạn muốn chuyển ngôn ngữ sang \(viewModel.pendingLang?.displayName ?? "")?",
            isPresented: $viewModel.showConfirmDialog,
            titleVisibility: .visible
        ) {
            Button("Thay đổi", role: .destructive) {
                viewModel.confirmChange()
            }
            Button("Huỷ", role: .cancel) {}
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
}
