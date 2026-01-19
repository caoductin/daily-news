//
//  SummaryResponseModel.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/19/26.
//

import Foundation


struct PostSummaryResponse: Decodable {
    let postId: String
    let lang: String
    let summary: SummaryPayload
}

struct SummaryPayload: Decodable {
    let summary: String
    let cached: Bool
}
