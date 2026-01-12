//
//  CategoryView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 15/6/25.
//

import Foundation
import SwiftUI

protocol LocalizableTab {
    var title: LocalizedStringKey { get }
}

enum CategoryTab: String, CaseIterable, Identifiable {
    case home
    case tech
    case sports
    case news
    case science
    case entertainment
    
    var id: String { self.rawValue }
}

extension CategoryTab: LocalizableTab {
    
    var title: LocalizedStringKey {
        switch self {
        case .home: return "Home"
        case .entertainment: return "Entertainment"
        case .tech: return "Tech"
        case .news: return "News"
        case .science: return "Science"
        case .sports: return "Sports"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return .blue
        case .tech : return .yellow
        case .sports: return .red
        case .news: return .green
        case .science: return .purple
        case .entertainment: return .orange
        }
    }
    
    var textColor: Color {
        color
    }
    
    var backgroundColor: Color {
        color.opacity(0.15)
    }
}

struct TopTabbar<T: RawRepresentable & Identifiable & CaseIterable & Equatable & LocalizableTab>: View where T.RawValue == String {
    @Namespace private var animation
    var tabs: [T]
    @Binding var currentTab: T
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(tabs) { tab in
                        TabItem(label: tab.title, isSelected: currentTab == tab)
                            .id(tab.id)
                            .onTapGesture {
                                withAnimation {
                                    currentTab = tab
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: currentTab) {oldtab, tab in
                withAnimation {
                    proxy.scrollTo(tab.id, anchor: .center)
                }
            }
        }
    }
    
    @ViewBuilder
    func TabItem(label: LocalizedStringKey, isSelected: Bool) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isSelected ? .blue : .gray)
            if isSelected {
                Capsule()
                    .fill(Color.blue)
                    .frame(height: 3)
                    .matchedGeometryEffect(id: "selection", in: animation)
            } else {
                Capsule()
                    .fill(Color.clear)
                    .frame(height: 3)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
    }
}
