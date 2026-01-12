//
//  PostTranslationViewModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 15/6/25.
//

import SwiftUI

import Foundation
import SwiftUI
import NaturalLanguage

@Observable
@MainActor
class PostDetailViewModel {
    var displayingPost: PostDetailModel
    var isLoading: Bool = false
    var errorMessage: String?
    var sumaryText: String?
    var isSummaryText: Bool = false
    private var translationCaches: [SupportedLang: PostDetailModel] = [:]
    private var sumaryTextCaches: [SupportedLang: String] = [:]
    private var originLang: SupportedLang = .vietnamese
    private var task: Task<Void, Never>? = nil
    
    init(post: PostDetailModel) {
        self.displayingPost = post
        Task {
            let detectLang = await Self.detectLanguage(of: post.content.htmlToPlainString())
            print("detetectLange \(detectLang)")
            originLang = detectLang ?? .vietnamese
            self.translationCaches[originLang] = post
        }
    }
    
    func translate(to lang: SupportedLang) async {
        if let cachesLange = translationCaches[lang] {
            self.displayingPost = cachesLange
            return
        }
        errorMessage = nil
        isLoading = true
        do {
            let translated = try await displayingPost.translate(lang.rawValue)
            translationCaches[lang] = translated
            displayingPost = translated
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print("Translation failed: \(error)")
        }
    }
    
    private func reset() {
        errorMessage = nil
        isLoading = false
    }
    
    func summaryText(to lang: SupportedLang, onCompleted: (() -> Void)? = nil) {
        var postSumary = displayingPost
        isSummaryText = true
        task = Task {
            do {
                if let cachesTranslate = checkCachesLanguage(.english) {
                    postSumary = cachesTranslate
                } else {
                    postSumary = try await postSumary.translate("en")
                    translationCaches[.english] = postSumary
                }
                            
                if let summaryTextCaches = sumaryTextCaches[lang] {
                    sumaryText = summaryTextCaches
                    isSummaryText = false
                    onCompleted?()
                    return
                } else if let summaryTextCacheEngLish = sumaryTextCaches[.english] {
                    let resultTranslate = try await TranslateViewModel.shared.translateTemp(text: summaryTextCacheEngLish.htmlToPlainString(), targetLanguage: lang.rawValue)
                    sumaryText = resultTranslate.translatedText
                    isSummaryText = false
                    onCompleted?()
                }
                
                let textToSummary = preprocessForSummarization(from: postSumary.content, title: postSumary.title)
                let body = ["text" : textToSummary]
                print("this is body \(body)")
                let response = try await APIServices.shared.sendRequestForTemp(from: URLAdvance.sumaryText.rawString, type: SumaryTextResponse.self, method: .POST, body: body)
                let translateSummary = try await TranslateViewModel.shared.translateTemp(text: response.summary.htmlToPlainString(), targetLanguage: lang.rawValue)
                print("this iss texxt \(response.summary)")
                print("summarytext \(isSummaryText)")
                await MainActor.run {
                    sumaryTextCaches[.english] = response.summary.htmlToPlainString()
                    sumaryText = translateSummary.translatedText.htmlToPlainString()
                    sumaryTextCaches[lang] = sumaryText
                    isSummaryText = false
                    onCompleted?()
                }
            } catch(let error) {
                await MainActor.run {
                    isSummaryText = false
                    onCompleted?()
                }
                print("error for sumary text \(error.localizedDescription)")
            }
        }
    }
    
    private func checkCachesLanguage(_ lang: SupportedLang) -> PostDetailModel? {
        if let cachesTranslate = translationCaches[lang] {
            return cachesTranslate
        }
        return nil
    }
    
    static func detectLanguage(of text: String) async -> SupportedLang? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        if let lang = recognizer.dominantLanguage,
           let supported = SupportedLang.from(lang: lang.rawValue) {
            return supported
        }
        return nil
    }
    
    func cancelTask() {
        task?.cancel()
        task = nil
    }
    
    private func preprocessForSummarization(from html: String, title: String? = nil) -> String {
        var text = html.htmlToPlainString()
        text = text
            .replacingOccurrences(of: "\n\n", with: "\n")
            .replacingOccurrences(of: "\t", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let lines = text.components(separatedBy: "\n")
            .filter { !$0.lowercased().contains("xem thêm") && !$0.lowercased().contains("facebook") }
        
        let cleaned = lines.joined(separator: " ")
        
        let words = cleaned.split(separator: " ").prefix(700)
        let coreText = words.joined(separator: " ")
        
        if let title = title, !title.isEmpty {
            return title + ". " + coreText
        } else {
            return coreText
        }
    }
}

struct SumaryTextResponse: Decodable {
    let summary: String
}
