//
//  TabBarButton.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import SwiftUI

struct TabBarButton: View {
    let icon: String
    let tab: Tab
    let title: String
    @Binding var selectedTab: Tab
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                    .padding(8)
                    .background(selectedTab == tab ? Color.blue.opacity(0.2) : Color.clear)
                    .clipShape(Circle())
                Text(title)
            }
        }
    }
    
}

#Preview {
    TabBarButton(icon: "square.and.arrow.up", tab: .home, title: "homeView", selectedTab: .constant(.home))
}
