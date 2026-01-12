//
//  TranslateRepository.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/12/26.
//

protocol TranslateRepository {
    func translate(
        text: String,
        from source: String,
        to target: String
    ) async throws -> TranslateTempResponse
    
}

struct TranslateRepositoryImpl: TranslateRepository {
    func translate(
        text: String,
        from soureLang: String,
        to targetLang: String
    ) async throws -> TranslateTempResponse {
        let body: [String: Any] = [
            "sourceLang": "auto",
            "targetLang": targetLang,
            "text": text
        ]
        let response = try await APIServices.shared.sendRequestForTemp(
            from: "translation/text",
            type: TranslateTempResponse.self,
            method: .POST,
            body: body
        )
        return response
    }
}

