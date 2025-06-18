//
//  CategoryView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 15/6/25.
//

import Foundation
import SwiftUI

struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

enum CategoryTab: String, CaseIterable, Identifiable {
    case home = "Tất cả"
    case tech = "Javascript"
    case sports = "Thể thao"
    case news = "Tin tức"
    case entertainment = "Giải trí"

    var id: String { self.rawValue }
}

struct CategoryTabView: View {
    @State private var currentCategory: CategoryTab = .home

    var body: some View {
        VStack(spacing: 0) {
            TopTab1(tabs: CategoryTab.allCases, currentTab: $currentCategory)

            TabView(selection: $currentCategory) {
                ForEach(CategoryTab.allCases) { category in
                    PostHomeView()
                        .tag(category)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .animation(.easeInOut, value: currentCategory)
    }
}

#Preview {
    CategoryTabView()
}


struct TopTab1<T: RawRepresentable & Identifiable & CaseIterable & Equatable>: View where T.RawValue == String {
    @Namespace private var animation
    var tabs: [T]
    @Binding var currentTab: T

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(tabs) { tab in
                        TabItem(label: tab.rawValue, isSelected: currentTab == tab)
                            .id(tab.id) // 👈 assign ID for scrolling
                            .onTapGesture {
                                withAnimation {
                                    currentTab = tab
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: currentTab) { tab in
                withAnimation {
                    proxy.scrollTo(tab.id, anchor: .center)
                }
            }
        }
    }

    @ViewBuilder
    func TabItem(label: String, isSelected: Bool) -> some View {
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
