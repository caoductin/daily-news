//
//  APIServices.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 15/5/25.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case POST
    case GET
    case PUT
    case DELETE
}

enum APIEndpoint {
    case getPosts
    case getPostsForUserId(userId: String)
    case deletePost(postId: String, userId: String)
    case getUser(id: String)
    case createPost
    case getComments(postId: String)
    case createComment
    case getPaginatedPosts(currentPage: Int, limit: Int)
    case translateText
    case getPostsRelated(postId: String)
    case login
    
    var path: String {
        switch self {
        case .getPosts:
            return "/api/post/getposts"
        case .getUser(let id):
            return "/api/users/\(id)"
        case .getPostsForUserId(let userId):
            return "/api/post/getposts?userId=\(userId)"
        case .deletePost(let postId,let userId):
            return "/api/post/deletepost/\(postId)/\(userId)"
        case .createPost:
            return "/api/post/create"
        case .getComments(let postId):
            return "/api/comment/getPostComments/\(postId)"
        case .createComment:
            return "/api/comment/create"
        case .getPaginatedPosts(let currentPage, let limit):
            return "/api/post/getPaginatedPosts?page=\(currentPage)&limit=\(limit)"
        case .translateText:
            return "/api/translate"
        case .getPostsRelated(let postId):
            return "/api/post/relatedPosts/\(postId)"
        case .login:
            return "api/auth/signin"
        }
    }
    
    var url: URL {
        return URL(string: "http://localhost:3000\(path)")!
    }
    
    var rawString: String {
        return "http://localhost:3000\(path)"
    }
}

enum URLAdvance {
    case sumaryText
    case translate
    
    var rawString: String {
        switch self {
        case .sumaryText:
            return "https://ductincao-pegasus-fastapi.hf.space/summarize"
        case .translate:
            return ""
        }
    }
}

class APIServices {
    static let shared = APIServices()
    
    private let baseURL = "http://localhost:3000"
    
    private init() {
        
    }
    
    func createRequest(
        url: URL,
        method: String,
        body: Data? = nil,
        headers: [String: String] = [:]
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let token = TokenManager.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("xxx \(token)")
        }
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    func sendRequest<T: Decodable>(
        from endpoint: APIEndpoint,
        type: T.Type,
        method: HTTPMethod = .GET,
        body: [String: Any]? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        let bodyData = body != nil ? try JSONSerialization.data(withJSONObject: body!) : nil
        let request = createRequest(url: endpoint.url, method: method.rawValue, body: bodyData, headers: headers)
        
        print("this is endponit uRL \(endpoint.url)")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if !(200..<300).contains(httpResponse.statusCode) {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.server(message: errorResponse.message)
            } else {
                throw APIError.unknown(statusCode: httpResponse.statusCode)
            }
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func sendRequestForTemp<T: Decodable>(
        from fullURL: String,
        type: T.Type,
        method: HTTPMethod = .GET,
        body: [String: Any]? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        let bodyData = body != nil ? try JSONSerialization.data(withJSONObject: body!) : nil
        let url = URL(string: fullURL)!
        var request = createRequest(url: url, method: method.rawValue, body: bodyData, headers: headers)
        request.timeoutInterval = 200
        print("this is full uRL \(url)")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if !(200..<300).contains(httpResponse.statusCode) {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.server(message: errorResponse.message)
            } else {
                throw APIError.unknown(statusCode: httpResponse.statusCode)
            }
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func sendRequest<T: Decodable, B: Encodable>(
        from endpoint: String,
        type: T.Type,
        method: HTTPMethod = .POST,
        body: B,
        headers: [String: String] = [:]
    ) async throws -> T {
        let bodyData = try JSONEncoder().encode(body)
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            print("url is not valid \(baseURL)\(endpoint)")
            throw URLError(.badURL)
        }
        
        let request = createRequest(url: url, method: method.rawValue, body: bodyData, headers: headers)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if !(200..<300).contains(httpResponse.statusCode) {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.server(message: errorResponse.message)
            } else {
                throw APIError.unknown(statusCode: httpResponse.statusCode)
            }
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func sendRequestString<T: Decodable>(
        from endpoint: String,
        type: T.Type,
        method: HTTPMethod = .POST,
        body: [String: Any]? = nil,
        headers: [String: String] = [:]) async throws -> T {
            let bodyData = body != nil ? try JSONSerialization.data(withJSONObject: body!) : nil
            
            guard let url = URL(string: "\(baseURL)\(endpoint)") else {
                print("url is not valid \(baseURL)\(endpoint)")
                throw URLError(.badURL)
            }
            print("this is url \(url)")
            let request = createRequest(url: url, method: method.rawValue, body: bodyData, headers: headers)

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            if !(200..<300).contains(httpResponse.statusCode) {
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    throw APIError.server(message: errorResponse.message)
                } else {
                    throw APIError.unknown(statusCode: httpResponse.statusCode)
                }
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
}


struct ErrorResponse: Decodable {
    let success: Bool
    let statusCode: Int
    let message: String
}

enum APIError: Error, LocalizedError {
    case server(message: String)
    case unknown(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .server(let message):
            return message
        case .unknown(let code):
            return "Unknown error occurred. Code: \(code)"
        }
    }
}
