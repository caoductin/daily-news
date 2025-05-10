//
//  TabBarButton.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import SwiftUI

struct TabBarButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    let systemIcon: String
    let title: String
    
    var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack {
                Image(systemName: systemIcon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .padding(.vertical, 8)
        }
        
    }
}

#Preview {
    StatefulPreviewWrapper(Tab.home) { selectedTab in
        TabBarButton(
            tab: .home,
            selectedTab: selectedTab,
            systemIcon: "house.fill",
            title: "Home"
        )
    }
}
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content
    
    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }
    
    var body: some View {
        content($value)
    }
}
