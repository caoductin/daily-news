//
//  TextBoxRecognizer.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 17/6/25.
//

import UIKit
import Vision

struct DetectedTextBox: Identifiable {
    let id = UUID()
    let originalText: String
    let boundingBox: CGRect // Normalized
    var translatedText: String? = nil
}

class TextBoxRecognizer {
    static let shared = TextBoxRecognizer()
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func recognizeText(from image: UIImage, completion: @escaping ([DetectedTextBox]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }
        
        let request = VNRecognizeTextRequest { request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion([])
                return
            }
            
            let results = observations.compactMap { observation -> DetectedTextBox? in
                guard let topText = observation.topCandidates(1).first else { return nil }
                return DetectedTextBox(originalText: topText.string, boundingBox: observation.boundingBox)
            }
            
            completion(results)
        }
        
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}

import SwiftUI

class ImageTranslateViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var detectedTextBoxes: [DetectedTextBox] = []
    @Published var isLoading: Bool = false
    @Published var selectedLang: String = "vi"
    
    private var imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        loadImageAndRecognizeText()
    }
    
    private func loadImageAndRecognizeText() {
        isLoading = true
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data, let uiImage = UIImage(data: data) else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }
            
            DispatchQueue.main.async {
                self.image = uiImage
                self.recognizeText(from: uiImage)
            }
        }.resume()
    }
    
    private func recognizeText(from image: UIImage) {
        TextBoxRecognizer.shared.recognizeText(from: image) { [weak self] boxes in
            DispatchQueue.main.async {
                self?.detectedTextBoxes = boxes
                self?.isLoading = false
            }
        }
    }
    
    func translateAllTexts() {
        guard !detectedTextBoxes.isEmpty else { return }
        
        for (index, box) in detectedTextBoxes.enumerated() {
            Task {
                let result = try await TranslateViewModel.shared.translateTemp(text: box.originalText, targetLanguage: selectedLang)
                await MainActor.run {
                    self.detectedTextBoxes[index].translatedText = result.translatedText
                }
            }
        }
    }
}

struct OverlayBoxView: View {
    let box: DetectedTextBox
    let imageSize: CGSize
    
    var body: some View {
        GeometryReader { geo in
            let frame = convertBoundingBox(box.boundingBox, imageSize: imageSize, viewSize: geo.size)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.green, lineWidth: 1)
                    .frame(width: frame.width, height: frame.height)
                    .position(x: frame.midX, y: frame.midY)
                
                if let translated = box.translatedText {
                    Text(translated)
                        .font(.system(size: 1000)) // Số lớn để scale xuống
                        .minimumScaleFactor(0.01) // Scale nhỏ lại để vừa khung
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: frame.width, height: frame.height)
                        .background(Color.black.opacity(0.6))
                        .position(x: frame.midX, y: frame.midY)
                }
            }
        }
    }
    
    func convertBoundingBox(_ boundingBox: CGRect, imageSize: CGSize, viewSize: CGSize) -> CGRect {
        // Vision: (0,0) bottom-left → SwiftUI: (0,0) top-left
        let x = boundingBox.origin.x * viewSize.width
        let height = boundingBox.size.height * viewSize.height
        let y = (1 - boundingBox.origin.y) * viewSize.height - height
        let width = boundingBox.size.width * viewSize.width
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

struct ImageTranslateView: View {
    @StateObject private var viewModel: ImageTranslateViewModel
    @State private var zoomScale: CGFloat = 1.0
    @State private var lastZoomScale: CGFloat = 1.0
    @State private var showTranslated = false

    init(imageURL: URL) {
        _viewModel = StateObject(wrappedValue: ImageTranslateViewModel(imageURL: imageURL))
    }
    
    var body: some View {
        let doubleTapGesture = TapGesture(count: 2)
            .onEnded {
                withAnimation(.easeInOut) {
                    if zoomScale == 1.0 {
                        zoomScale = 2.5
                    } else {
                        zoomScale = 1.0
                    }
                }
            }
        return VStack {
            Picker("Ngôn ngữ đích", selection: $viewModel.selectedLang) {
                Text("🇻🇳 Tiếng Việt").tag("vi")
                Text("🇺🇸 English").tag("en")
                Text("🇯🇵 Japanese").tag("ja")
            }
            .pickerStyle(.menu)
            .padding()
            
            Toggle("Hiển thị bản dịch", isOn: $showTranslated)
                .padding(.horizontal)
                .padding(.bottom, 5)
                .disabled(viewModel.image == nil || viewModel.detectedTextBoxes.isEmpty)
                .onChange(of: showTranslated) { newValue in
                    if newValue {
                        viewModel.translateAllTexts()
                    }
                }
            
            if viewModel.isLoading {
                ProgressView("Đang tải và nhận diện...")
            } else if let image = viewModel.image {
                GeometryReader { geo in
                    let imageSize = image.size
                    let viewWidth = geo.size.width
                    let aspectRatio = imageSize.width / imageSize.height
                    let imageDisplayHeight = viewWidth / aspectRatio
                    let actualImageFrame = CGSize(width: viewWidth, height: imageDisplayHeight)
                    
                    ScrollView([.horizontal, .vertical], showsIndicators: false) {
                        ZStack(alignment: .topLeading) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: actualImageFrame.width, height: actualImageFrame.height)
                                .scaleEffect(zoomScale)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            zoomScale = lastZoomScale * value
                                        }
                                        .onEnded { _ in
                                            lastZoomScale = zoomScale
                                        }
                                )
                            if showTranslated {
                                ForEach(viewModel.detectedTextBoxes) { box in
                                    OverlayBoxView(box: box, imageSize: imageSize)
                                        .frame(width: actualImageFrame.width, height: actualImageFrame.height)
                                        .scaleEffect(zoomScale)
                                }
                            }
                        }
                        .frame(width: actualImageFrame.width * zoomScale, height: actualImageFrame.height * zoomScale)
                        .contentShape(Rectangle())
                        .gesture(doubleTapGesture)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
                
            }
            
            Spacer()
        }
        .onChange(of: viewModel.selectedLang) { newLang in
            if showTranslated {
                viewModel.translateAllTexts()
            }
        }
        .navigationTitle("Dịch ảnh")
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    if let url = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMnMRRcbuyFz49zhCy1EiGTG3vPDGgggVRmg&s") {
        ImageTranslateView(imageURL: url)
    } else {
        Text("URL không hợp lệ")
    }
}
