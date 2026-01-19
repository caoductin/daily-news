//
//  SearchRepository.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/19/26.
//

import Foundation

protocol SearchRepository {
    func search(query: String) async throws -> [PostDetailResponse]
}

struct SearchRepositoryImpl: SearchRepository {
    func search(query: String) async throws -> [PostDetailResponse] {
        let body = ["query": query]
        let data = try await APIServices.shared.sendRequest(
            from: APIEndpoint.searchSemantic,
            type: [PostDetailResponse].self,
            method: .POST,
            body: body
        )
        return data
    }
}
