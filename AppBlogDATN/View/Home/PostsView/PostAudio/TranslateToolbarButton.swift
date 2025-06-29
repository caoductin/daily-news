//
//  TranslateToolbarButton.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 15/6/25.
//

import SwiftUI

struct TranslateToolbarButton: View {
    @Binding var selectedLang: SupportedLang
    var resultLanguage: ((SupportedLang) -> Void)?
    var body: some View {
        Menu {
            ForEach(SupportedLang.allCases) { lang in
                Button {
                    selectedLang = lang
                    resultLanguage?(lang)
                } label: {
                    Label(lang.displayName, systemImage: lang == selectedLang ? "checkmark" : "")
                }
            }
        } label: {
            Image(systemName: "globe")
        }
    }
}
