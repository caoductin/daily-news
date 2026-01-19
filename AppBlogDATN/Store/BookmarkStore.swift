//
//  BookmarkStore.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/9/26.
//

import Foundation
import SwiftUI

@Observable
@MainActor
class PostStore {
    
    private(set) var postsById: [String: PostDetailModel] = [:]
    
    private var translatedPosts: [String: PostDetailModel] = [:]
    
    // MARK: - State
    var isTranslateEnabled: Bool = false
    var currentLanguage: String {
        UserDefaults.standard.string(forKey: "appLanguage") ?? "vi"
    }
    // MARK: - Write
    
    func remove(_ postId: String) {
        postsById.removeValue(forKey: postId)
    }
    
    func insert(_ post: PostDetailModel) {
        postsById[post.id] = post
        
        let key = translateKey(postId: post.id)
        if var translated = translatedPosts[key] {
            translated.isBookmarked = post.isBookmarked
            translatedPosts[key] = translated
        }
    }
    
    func upsert(_ posts: [PostDetailModel]) {
        for post in posts {
            insert(post)
        }
    }
    
    func update(postId: String, transform: (inout PostDetailModel) -> Void) {
        guard var post = postsById[postId] else { return }
        transform(&post)
        postsById[postId] = post
        
        let key = translateKey(postId: postId)
        if var translated = translatedPosts[key] {
            transform(&translated)
            translatedPosts[key] = translated
        }
        
        postsById = postsById
    }
    
    // MARK: - Read
    
    func post(id: String) -> PostDetailModel? {
        
        guard isTranslateEnabled else {
            return postsById[id]
        }
        
        let key = translateKey(postId: id)
        
        if let translated = translatedPosts[key] {
            return translated
        }
        
        return postsById[id]
    }
    
    func posts(ids: [String]) -> [PostDetailModel] {
        ids.compactMap { post(id: $0) }
    }
    
    func allPosts() -> [PostDetailModel] {
        Array(postsById.values)
    }
}

extension PostStore {
    
    private func translateKey(postId: String) -> String {
        "\(postId)_\(currentLanguage)"
    }
    
    func toggleTranslate() {
        withAnimation {
            isTranslateEnabled.toggle()
            postsById = postsById
        }
    }
    
    func translateTitlesIfNeeded(
        postIds: [String],
        service: PostTranslateService
    ) async {
        
        for id in postIds {
            let key = translateKey(postId: id)
            
            if translatedPosts[key] != nil { continue }
            guard let original = postsById[id] else { continue }
            
            do {
                let translated = try await service.translate(
                    post: original,
                    scope: .titleOnly,
                    targetLang: currentLanguage
                )
                translatedPosts[key] = translated
            } catch {
                print("❌ Translate title failed for \(error)")
            }
        }
    }
}

