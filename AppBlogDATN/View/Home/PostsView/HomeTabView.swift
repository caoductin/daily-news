//
//  HomeTabView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 15/6/25.
//

import SwiftUI

struct HomeTabView: View {
    @State private var currentCategory: CategoryTab = .home
    @State private var viewModel = PostViewModel()
    @Environment(HomeCoordinator.self) private var homeCoordinator
    
    var postRelated: PostDetailResponse = PostDetailResponse.mock(id: "123")
    var body: some View {
        VStack(spacing: 0) {
            TopTab1(tabs: CategoryTab.allCases, currentTab: $currentCategory)
            
            TabView(selection: $currentCategory) {
                ForEach(CategoryTab.allCases) { category in
                    if category == .home {
                        NavigationStack {
                            PostHomeView()
                        }
                    } else {
                        PostListCategoryView(
                            postListView: viewModel.filteredPosts
                        )
                        .tag(category)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .onChange(of: currentCategory) { oldTab, newTab in
            withAnimation(.easeInOut) {
                viewModel.selectedCategory = newTab
            }
        }
        .task {
            await viewModel.getPost()
        }
    }
}

#Preview {
    NavigationStack {
        let coordinator = HomeCoordinator()
        HomeModule(coordinator: coordinator)
            .environment(coordinator)
    }
}
