//
//  HomeTabView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 15/6/25.
//

import SwiftUI

struct HomeTabView: View {
    @State private var currentCategory: Category = .home
    @Environment(PostStore.self) private var postStore
    @State private var viewModel = PostViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            TopTabbar(tabs: Category.allCases, currentTab: $currentCategory)
            
            TabView(selection: $currentCategory) {
                ForEach(Category.allCases) { category in
                    if category == .home {
                        PostHomeModule.makeView(postStore: postStore)
                            .tag(category)
                    } else {
                        CategoryModule.makeView(category, postStore)
                            .tag(category)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            HStack {
                Spacer()
                Text(currentCategory.title)
                    .font(.headline)
                Button {
                    Task {
                        if postStore.isTranslateEnabled {
                            withAnimation {
                                postStore.isTranslateEnabled = false
                            }
                        } else {
                            let postIds = postStore.allPosts().map(\.id)

                            await postStore.translateTitlesIfNeeded(
                                postIds: postIds,
                                service: PostTranslateServiceImpl(
                                    translateUseCase: TranslateTextUseCase(
                                        postRepository: PostRepositoryImpl(),
                                        translationRepository: TranslateRepositoryImpl()
                                    )
                                )
                            )
                            postStore.toggleTranslate()
                        }
                    }
                } label: {
                    Image(systemName: postStore.isTranslateEnabled
                          ? "globe"
                          : "globe")
                }

            }
            .padding()
        }
        .onChange(of: currentCategory) { oldTab, newTab in
            withAnimation(.easeInOut) {
                viewModel.selectedCategory = newTab
            }
        }
        .alert("Confirm", isPresented: $viewModel.showAlert) {
            Button("Oke", role: .cancel) {
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack {
        let coordinator = HomeCoordinator()
        HomeModule(homeCoordinator: coordinator)
    }
}
