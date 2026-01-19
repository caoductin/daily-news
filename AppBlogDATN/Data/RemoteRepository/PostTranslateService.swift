//
//  PostTranslateService.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/15/26.
//
import SwiftUI
import Foundation

enum TranslateScope: String {
    case titleOnly
    case fullContent
}

protocol PostTranslateService {
    func translate(
        post: PostDetailModel,
        scope: TranslateScope,
        targetLang: String
    ) async throws -> PostDetailModel
}

struct PostTranslateServiceImpl: PostTranslateService {

    let translateUseCase: TranslateTextUseCase

    func translate(
        post: PostDetailModel,
        scope: TranslateScope,
        targetLang: String
    ) async throws -> PostDetailModel {

        async let titleResult = translateUseCase.execute(
            text: post.title,
            target: targetLang
        )

        let translatedTitle = try await titleResult

        var translatedContent = post.content

        if scope == .fullContent {
            let contentResult = try await translateUseCase.execute(
                text: post.content,
                target: targetLang
            )
            translatedContent = contentResult.translatedText
        }

        return PostDetailModel(
            id: post.id,
            userId: post.userId,
            content: translatedContent,
            category: post.category,
            title: translatedTitle.translatedText,
            slug: post.slug,
            image: post.image,
            createdAt: post.createdAt,
            updatedAt: post.updatedAt,
            isBookmarked: post.isBookmarked
        )
    }
}
