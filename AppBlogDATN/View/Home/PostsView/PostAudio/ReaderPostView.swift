//
//  ReaderPostView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 14/6/25.
//

import AVFoundation
import SwiftUI
import SwiftUI

struct SpeechTestView: View {
    @State private var viewModel = SpeechViewModel()
    @State private var showVolumeSlider = false
    var selectedLanguage: String = "vi"
    var textToSpeech: String

    let speakingRates: [Float] = [0.5, 1.0, 1.5, 2.0]

    var buttonIcon: String {
        if viewModel.isSpeaking {
            return viewModel.isPaused ? "play.circle.fill" : "pause.circle.fill"
        } else {
            return "play.circle.fill"
        }
    }
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Picker("Voice", selection: $viewModel.voicePreference) {
                        Text("System").tag(VoicePreference.systemDefault)
                        Text("Male").tag(VoicePreference.preferMale)
                        Text("Female").tag(VoicePreference.preferFemale)
                    }
                    .pickerStyle(.menu)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    if viewModel.isSpeaking {
                        viewModel.isPaused ? viewModel.continueSpeaking() : viewModel.pauseSpeaking()
                    } else {
                        viewModel.startSpeaking()
                    }
                } label: {
                    Image(systemName: buttonIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                .disabled(viewModel.inputText.isEmpty)
                .frame(maxWidth: .infinity, alignment: .center)
                HStack(spacing: 3) {
                    Picker("Speed", selection: $viewModel.rate) {
                        ForEach(speakingRates, id: \.self) { rate in
                            Text(String(format: "%.1fx", rate)).tag(rate)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    VolumeMenuButton(volume: $viewModel.volume)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button {
                    viewModel.stopSpeaking()
                } label: {
                    Text("Stop")
                }

                
            }
            .padding(.horizontal)


            ProgressView(value: viewModel.progress)
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.top)

            Spacer()
        }
        .onAppear {
            viewModel.inputText = textToSpeech
            viewModel.selectedLanguage = selectedLanguage
        }

        .onChange(of: textToSpeech) { newText in
            viewModel.updateTextAndRestartIfNeeded(newText)
        }

        .onChange(of: selectedLanguage) { newLang in
            viewModel.updateLanguageAndRestartIfNeeded(newLang)
        }
        .padding()
        .navigationTitle("🗣️ TTS Demo")
    }
}


struct VolumeMenuButton: View {
    @Binding var volume: Float
    @State private var showMenu = false

    var body: some View {
        ZStack {
            // Nút âm lượng
            Button(action: {
                withAnimation {
                    showMenu.toggle()
                }
            }) {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.title2)
                    .padding(8)
            }

            if showMenu {
                Color.clear
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }

                VStack(spacing: 6) {
                    Slider(value: $volume, in: 0...1)
                        .rotationEffect(.degrees(-90))
                        .frame(height: 140) // 👈 Tăng chiều dài
                        .padding(.horizontal, 8)

                    Text(String(format: "%.1f", volume))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .frame(width: 60)
                .offset(x: 0, y: 70)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(width: 44, height: 44)
    }
}


import AVFoundation
import Foundation
import Combine


enum VoicePreference {
    case systemDefault
    case preferMale
    case preferFemale
}

@Observable
class SpeechViewModel: NSObject, AVSpeechSynthesizerDelegate {
    // MARK: - Published Properties
    static let shared = SpeechViewModel()
    var inputText: String = ""
    var progress: Double = 0.0
    var isSpeaking = false
    var isPaused = false
    var volume: Float = 1.0 // 0.0 to 1.0
    var rate: Float = 0.5   // ~0.3 to ~0.6 for best effect
    var selectedLanguage: String = "en-US"
    var voicePreference: VoicePreference = .systemDefault

    // MARK: - Private Properties
    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?
    private var totalLength: Int = 1

    // MARK: - Init
    override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Voice Selection
    func selectVoice(language: String, preference: VoicePreference) -> AVSpeechSynthesisVoice? {
        let voices = AVSpeechSynthesisVoice.speechVoices().filter { $0.language == language }

        // Ưu tiên Premium/Enhanced nếu có
        let sorted = voices.sorted { $0.quality.rawValue > $1.quality.rawValue }

        switch preference {
        case .systemDefault:
            return AVSpeechSynthesisVoice(language: language)
        case .preferMale:
            return sorted.first(where: { $0.gender == .male }) ?? AVSpeechSynthesisVoice(language: language)
        case .preferFemale:
            return sorted.first(where: { $0.gender == .female }) ?? AVSpeechSynthesisVoice(language: language)
        }
    }

    // MARK: - Speaking Control
    func startSpeaking() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        try? AVAudioSession.sharedInstance().setActive(true)

        let utterance = AVSpeechUtterance(string: inputText)
        utterance.rate = max(0.3, min(rate, 0.6)) // Clamp for natural sound
        utterance.volume = max(0.0, min(volume, 1.0))
        utterance.pitchMultiplier = 1.0 // Keep neutral pitch

        if let voice = selectVoice(language: selectedLanguage, preference: voicePreference) {
            utterance.voice = voice
            print("🎙 Voice: \(voice.name) — \(voice.language) — \(voice.quality) — \(voice.gender)")
        } else {
            print("⚠️ No voice found for: \(selectedLanguage)")
        }

        currentUtterance = utterance
        totalLength = inputText.count
        progress = 0
        isSpeaking = true
        isPaused = false

        synthesizer.speak(utterance)
    }

    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
        isPaused = false
        progress = 0
    }

    func pauseSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .word)
            isPaused = true
        }
    }

    func continueSpeaking() {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            isPaused = false
        }
    }
    
    func updateLanguageAndRestartIfNeeded(_ newLang: String) {
        if isSpeaking {
            stopSpeaking()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.selectedLanguage = newLang
                self.startSpeaking()
            }
        } else {
            self.selectedLanguage = newLang
        }
    }

    func updateTextAndRestartIfNeeded(_ newText: String) {
        if isSpeaking {
            stopSpeaking()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.inputText = newText
                self.startSpeaking()
            }
        } else {
            self.inputText = newText
        }
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.progress = Double(characterRange.location + characterRange.length) / Double(self.totalLength)
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.progress = 1.0
        }
    }
}
