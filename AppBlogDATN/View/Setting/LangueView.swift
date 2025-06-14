////
////  LangueView.swift
////  AppBlogDATN
////
////  Created by cao duc tin  on 13/6/25.
////
//
//import SwiftUI
//
////struct LangueView: View {
////    var body: some View {
////        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
////    }
////}
////
////#Preview {
////    LangueView()
////}
//import Translation
//import SwiftUI
//import MLKitTranslate
//import SwiftUI
//
//struct TranslateView: View {
//    @State private var inputText = "Xin chào"
//    @State private var translatedText = ""
//    @State private var isTranslating = false
//    @State private var fromLang: SupportedLang = .vietnamese
//    @State private var toLang: SupportedLang = .english
//
//    var body: some View {
//        VStack(spacing: 20) {
//            // Language Pickers
//            HStack {
//                Picker("From", selection: $fromLang) {
//                    ForEach(SupportedLang.allCases, id: \.self) { lang in
//                        Text(lang.rawValue).tag(lang)
//                    }
//                }
//                .pickerStyle(.menu)
//
//                Button(action: swapLanguages) {
//                    Image(systemName: "arrow.left.arrow.right")
//                }
//
//                Picker("To", selection: $toLang) {
//                    ForEach(SupportedLang.allCases, id: \.self) { lang in
//                        Text(lang.rawValue).tag(lang)
//                    }
//                }
//                .pickerStyle(.menu)
//            }
//
//            // Input Text
//            TextEditor(text: $inputText)
//                .frame(height: 120)
//                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
//
//            // Translate Button
//            Button(action: {
//                translate()
//            }) {
//                Text("Dịch")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//
//            // Output
//            if isTranslating {
//                ProgressView("Đang dịch...")
//            } else {
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("Kết quả:")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    Text(translatedText)
//                        .font(.title3)
//                        .bold()
//                        .padding(.top, 4)
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }
//
//            Spacer()
//        }
//        .padding()
//    }
//
//    func swapLanguages() {
//        let temp = fromLang
//        fromLang = toLang
//        toLang = temp
//    }
//
//    func translate() {
//        isTranslating = true
//        translatedText = ""
//        TranslatorManager.shared.translate(
//            text: inputText,
//            from: fromLang,
//            to: toLang
//        ) { result in
//            DispatchQueue.main.async {
//                isTranslating = false
//                switch result {
//                case .success(let text):
//                    translatedText = text
//                case .failure(let error):
//                    translatedText = "X \(error.localizedDescription)"
//                }
//            }
//        }
//    }
//}
