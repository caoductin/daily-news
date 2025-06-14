//
//  SegmentPickerView.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/11/25.
//

import SwiftUI

struct SegmentPickerView: View {
    @State var selected = 1
    let title = ["Sign In", "Sign up"]
    var body: some View {
        HStack {
            ForEach(0..<title.count, id: \.self) { index in
                Button {
                    selected = index
                } label: {
                    VStack {
                        Text(title[index])
                            .fontWeight(selected == index ? .bold : .regular)
                        Divider()
                    }
                    
                }
            }
        }
    }
}

struct TopTab: View {
    @Namespace private var animation
    var tabs: [String]
    @Binding var currentTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.element.self){ index, label in
                TabItem(label: label, isSelected: currentTab == index)
                    .onTapGesture {
                        withAnimation {
                            currentTab = index
                        }
                    }
            }
        }

    }
    
    @ViewBuilder
    func TabItem(label: String, isSelected: Bool) -> some View {
        Text(label)
            .fontWeight(.semibold)
            .lineLimit(1)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .foregroundStyle(isSelected ? .blue : .secondary)
            .overlay(alignment: .bottom){
                if isSelected {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.blue)
                        .frame(height: 4)
                        .matchedGeometryEffect(id: "selection", in: animation)
                        .padding(.horizontal, 16)
                } else {
                    Color.clear
                }
            }
    }
}

struct tesstView : View {
    @State var currentTabIndex = 0
    let tab = ["sign in", "Sign up"]
    var body: some View {
        TopTab(tabs: tab, currentTab: $currentTabIndex)
    }
}

#Preview {
    tesstView()
}
