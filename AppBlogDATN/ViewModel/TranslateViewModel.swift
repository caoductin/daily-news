//
//  TranslateViewModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 3/6/25.
//

import UIKit
import Foundation

struct TranslateResponse: Decodable {
    let originalText: String
    let translatedText: String
    let languageDetected: String
}

class TranslateViewModel {
    static let shared = TranslateViewModel()
    
    func translate(text: String, targetLanguage: String) async throws -> TranslateResponse {
        let body: [String: Any] = [
            "text": text,
            "targetLang": targetLanguage
        ]
        let response: TranslateResponse = try await APIServices.shared.sendRequest(
            from: .translateText,
            type: TranslateResponse.self,
            method: .POST,
            body: body
        )
        return response
    }
    
}
