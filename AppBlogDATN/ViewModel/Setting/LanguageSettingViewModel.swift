//
//  LanguageSettingViewModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 14/6/25.
//

import Foundation
import SwiftUI

@MainActor
class LanguageSettingViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedLang: SupportedLang
    @Published var showConfirmDialog = false
    @Published var pendingLang: SupportedLang?
    
    @AppStorage("appLanguage") private var appLanguage: String = SupportedLang.vietnamese.rawValue
    
    init() {
        let storedLang = UserDefaults.standard.string(forKey: "appLanguage") ?? SupportedLang.vietnamese.rawValue
        let current = SupportedLang(rawValue: storedLang) ?? .vietnamese
        _selectedLang = Published(initialValue: current)
    }
    
    var filteredLanguages: [SupportedLang] {
        if searchText.isEmpty {
            return SupportedLang.allCases
        } else {
            return SupportedLang.allCases.filter {
                $0.displayName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func requestSelect(lang: SupportedLang) {
        guard lang != selectedLang else { return }
        pendingLang = lang
        showConfirmDialog = true
    }
    
    func confirmChange() {
        guard let newLang = pendingLang else { return }
        selectedLang = newLang
        appLanguage = newLang.rawValue
        LocalizationManager.shared.setLanguage(newLang.rawValue)
        pendingLang = nil
    }
}
