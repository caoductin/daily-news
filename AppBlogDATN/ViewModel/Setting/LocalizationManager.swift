//
//  LocalizationManager.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 14/6/25.
//

import Foundation

import Foundation

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

class LocalizationManager {
    static let shared = LocalizationManager()
    private init() {}

    private(set) var bundle: Bundle = .main

    func setLanguage(_ langCode: String) {
        if let path = Bundle.main.path(forResource: langCode, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
        } else {
            self.bundle = .main
        }
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }

    func localizedString(for key: String) -> String {
        bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}

extension String {
    var localized: String {
        LocalizationManager.shared.localizedString(for: self)
    }
}
