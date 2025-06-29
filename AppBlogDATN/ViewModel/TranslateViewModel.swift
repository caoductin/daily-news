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

struct TranslateTempResponse: Decodable {
    let sourceLang: String
    let targetLang: String
    let translatedText: String
}

class TranslateViewModel: ObservableObject {
    static let shared = TranslateViewModel()
    @Published var isTranslating: Bool = false
    @Published var originText: String?
    
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
    
    func translateTemp(text: String, targetLanguage: String) async throws -> TranslateTempResponse {
        let body: [String: Any] = [
            "sourceLang": "auto",
            "targetLang": targetLanguage,
            "text": text
        ]
        let response: TranslateTempResponse = try await APIServices.shared.sendRequestForTemp(
            from: "https://mimamoriai.com/api/translation/text",
            type: TranslateTempResponse.self,
            method: .POST,
            body: body
        )
        return response
    }
    
    func translateForLang(_ originText: String, _ lang: SupportedLang) async -> String {
        var resultString = originText
        let langSnapshot = lang
        await MainActor.run { isTranslating = true }
        
        do {
            let response = try await TranslateViewModel.shared.translateTemp(
                text: originText, targetLanguage: langSnapshot.rawValue
            )
            resultString = response.translatedText
            print("this is result\(resultString)")
            await MainActor.run {
                isTranslating = false
            }
            
        } catch {
            await MainActor.run {
                isTranslating = false
            }
            print("❌ Lỗi dịch: \(error)")
            return error.localizedDescription
        }
        return resultString
    }
    
    
    //https://mimamoriai.com/api/translation/text
    
}
