//
//  PostSumarryRepository.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/19/26.
//

protocol PostSummaryRepository {
    func getSummaryPost(postID: String, language: String) async throws -> PostSummaryResponse
}

struct PostSumarryRepositoryImpl: PostSummaryRepository {
    func getSummaryPost(postID: String, language: String) async throws -> PostSummaryResponse {
        let data = try await APIServices.shared.sendRequest(
            from: APIEndpoint.getSummaryPost(postID: postID, lang: language),
            type: PostSummaryResponse.self,
            method: .POST
        )
        return data
    }
}
