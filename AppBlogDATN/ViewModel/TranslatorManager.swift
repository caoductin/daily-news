////
////  TranslatorManager.swift
////  AppBlogDATN
////
////  Created by cao duc tin  on 14/6/25.
////
//
//import Foundation
//import MLKitTranslate
//import Translation
//
//enum SupportedLang: String, CaseIterable {
//    case vietnamese = "Vietnamese"
//    case japanese = "Japanese"
//    case english = "English"
//    var mlkitLanguage: TranslateLanguage {
//        switch self {
//        case .english:
//            return .english
//        case .vietnamese:
//            return .vietnamese
//        case .japanese:
//            return .japanese
//        }
//    }
//    
//}
//
//class TranslatorManager: ObservableObject {
//    static let shared = TranslatorManager()
//    
//    private var translators: [String: Translator] = [:]
//    private var downloadedModels: Set<String> = []
//    
//    private init() {
//        preloadInitialModels()
//    }
//    
//    // MARK: - Public API
//    func translate(text: String,
//                   from sourceLang: SupportedLang,
//                   to targetLang: SupportedLang,
//                   completion: @escaping (Result<String, Error>) -> Void) {
//        
//        let source = sourceLang.mlkitLanguage
//        let target = targetLang.mlkitLanguage
//        let key = "\(source.rawValue)->\(target.rawValue)"
//        
//        let translator: Translator
//        if let cached = translators[key] {
//            translator = cached
//        } else {
//            let options = TranslatorOptions(sourceLanguage: source, targetLanguage: target)
//            translator = Translator.translator(options: options)
//            translators[key] = translator
//        }
//        
//        if !downloadedModels.contains(key) {
//            let conditions = ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true)
//            translator.downloadModelIfNeeded(with: conditions) { [weak self] error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                self?.downloadedModels.insert(key)
//                self?.performTranslation(translator: translator, text: text, completion: completion)
//            }
//        } else {
//            performTranslation(translator: translator, text: text, completion: completion)
//        }
//    }
//    
//    // MARK: - Internal Helpers
//    private func performTranslation(translator: Translator, text: String, completion: @escaping (Result<String, Error>) -> Void) {
//        translator.translate(text) { result, error in
//            if let result = result {
//                completion(.success(result))
//            } else {
//                completion(.failure(error ?? NSError(domain: "Unknown translation error", code: 0)))
//            }
//        }
//    }
//    
//    // MARK: - Preload Models on Init
//    private func preloadInitialModels() {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            let languagePairs: [(SupportedLang, SupportedLang)] = [
//                (.vietnamese, .english),
//                (.english, .vietnamese),
//                (.vietnamese, .japanese),
//                (.japanese, .vietnamese)
//            ]
//            
//            for (sourceLang, targetLang) in languagePairs {
//                let source = sourceLang.mlkitLanguage
//                let target = targetLang.mlkitLanguage
//                let key = "\(source.rawValue)->\(target.rawValue)"
//                
//                let options = TranslatorOptions(sourceLanguage: source, targetLanguage: target)
//                let translator = Translator.translator(options: options)
//                
//                DispatchQueue.main.async {
//                    self?.translators[key] = translator
//                }
//                
//                let conditions = ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true)
//                
//                translator.downloadModelIfNeeded(with: conditions) { error in
//                    if error == nil {
//                        DispatchQueue.main.async {
//                            self?.downloadedModels.insert(key)
//                        }
//                        print("✅ Preloaded model for: \(key)")
//                    } else {
//                        print("❌ Failed to preload model \(key): \(error!.localizedDescription)")
//                    }
//                }
//            }
//        }
//    }
//    
//}
