//
//  PostSummaryUseCase.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/19/26.
//

import Foundation


struct PostSummaryUseCase {
    let repository: PostSummaryRepository
        
    func excute(postID: String, language: String) async throws -> SummaryPayload {
        let data = try await repository.getSummaryPost(postID: postID, language: language)
        return data.summary
    }
}
