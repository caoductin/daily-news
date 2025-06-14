//
//  ReaderPostView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 14/6/25.
//

import SwiftUI
import SwiftUI
import AVFoundation

struct ReaderPostView: View {
    @State private var inputText: String = "Xin chào, mình là iOS!"
    private let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 20) {
            Text("🎙️ Text-to-Speech Demo")
                .font(.title2)
                .bold()

            TextField("Nhập nội dung muốn đọc...", text: $inputText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button(action: speakText) {
                Label("Phát giọng nói", systemImage: "speaker.wave.2.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top, 50)
    }

    private func speakText() {
        let utterance = AVSpeechUtterance(string: inputText)
        utterance.voice = AVSpeechSynthesisVoice(language: "vi-VN")
        utterance.rate = 0.5 // Tốc độ nói (0.0 - 1.0)
        synthesizer.speak(utterance)
    }
}


#Preview {
    ReaderPostView()
}
