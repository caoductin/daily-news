//
//  SearchPostUseCase.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/19/26.
//

import Foundation

struct SearchPostUseCase {
    let repository: SearchRepository
    
    func excute(query: String) async throws -> [PostDetailModel] {
        let data = try await repository.search(query: query)
        return data.map{ $0.toDomain()}
    }
    
}
