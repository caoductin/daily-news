//
//  TranslateTextUseCase.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/12/26.
//

struct TranslateTextUseCase {
    let postRepository: PostRepository
    let translationRepository: TranslateRepository
    
    func execute(text: String, target: String) async throws -> TranslateTempResponse {
        let data = try await translationRepository.translate(text: text, from: "auto", to: target)
        return data
    }
}

