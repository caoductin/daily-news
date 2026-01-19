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
    private var translationCaches: [SupportedLang: PostDetailModel] = [:]
    private var originLang: SupportedLang = .vietnamese
    private var task: Task<Void, Never>? = nil
    
    private let summaryUseCase: PostSummaryUseCase = {
        let repo = PostSumarryRepositoryImpl()
        return PostSummaryUseCase(repository: repo)
    }()
    
    init(post: PostDetailModel) {
        self.displayingPost = post
        Task {
            let detectLang = await Self.detectLanguage(of: post.content.htmlToPlainString())
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
    
    func loadSummaryText(lang: SupportedLang) async {
        isLoading = true
        errorMessage = nil
        print("this is selected langaue\(lang)")
        do {
            defer {
                isLoading = false
            }
            let result = try await summaryUseCase.excute(
                postID: displayingPost.id,
                language: lang.rawValue
            )
            print("this is summaryText\(result)")
            self.sumaryText = result.summary
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
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
