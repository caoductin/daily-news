//
//  InfiniteCasualView.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/14/26.
//

import SwiftUI

struct InfiniteCarouseView: View {
    let imageNames: [String]
    let vlocity: CGFloat
    
    init(imageNames: [String],_ vlocity: CGFloat) {
        self.imageNames = imageNames
        self.vlocity = vlocity
        var items: [ImageItem] = []
        
        items.append(contentsOf: imageNames.map { ImageItem(id: UUID(), imageString: String($0))})
        items.append(contentsOf: imageNames.map { ImageItem(id: UUID(), imageString: String($0))})
        items.append(contentsOf: imageNames.map { ImageItem(id: UUID(), imageString: String($0))})

        imageItems = items
        carouseCardLength = (CarouseCard.itemSize.width + 8) * CGFloat(imageNames.count)
    }
    
    private let imageItems: [ImageItem]
    private let carouseCardLength: CGFloat
    private var itemSpacing = 8.0

    @State private var scrollPosition = ScrollPosition()
    @State private var timer =
        Timer
        .publish(every: 0.04, on: .main, in: .default)
        .autoconnect()
    @State private var x: CGFloat = 0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: itemSpacing) {
                ForEach(imageItems) { imageName in
                    Button {
                        withAnimation {
                            scrollPosition.scrollTo(id: imageName.imageString)
                        }
                    } label: {
                        CarouseCard(image: imageName.imageString)
                            .id(imageName.imageString)

                    }
                }
            }
        }
        .scrollClipDisabled()
        .scrollPosition($scrollPosition, anchor: .center)
        .onReceive(timer) { _ in
            if x > carouseCardLength * 2 || x < 0 {
                x = carouseCardLength
            } else {
                x = x + vlocity
            }
        }
        .onChange(of: x) { oldValue, newValue in
            scrollPosition.scrollTo(x: x)
        }
        .onScrollPhaseChange({ oldPhase, newPhase in
            switch(oldPhase, newPhase) {
            case (.idle, .idle):
                break
            case (_, .interacting):
                timer = Timer
                    .publish(every: 0.01, on: .main, in: .default)
                    .autoconnect()
            default:
                break
            }
        })
        .onScrollGeometryChange(for: Double.self, of: { scrollGeometry in
            scrollGeometry.contentOffset.x
        }, action: { oldValue, newValue in
            x = newValue
        })
    }
}

struct ImageItem: Identifiable {
    let id: UUID
    let imageString: String
}

struct CarouseCard: View {
    let image: String
    static let itemSize = CGSize(width: 100, height: 120)

    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: Self.itemSize.width, height: Self.itemSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 4)
        }
    }
}
#Preview {
    let imageName = (1...7).map {String($0)}
    InfiniteCarouseView(imageNames: imageName, 1.0)
}

