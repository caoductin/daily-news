//
//  PostDetailView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 16/5/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetailView: View {
    @StateObject var commentsPost: CommentViewModel = CommentViewModel()
    @StateObject var postRelatedVM: PostRelatedViewModel = {
        let repository = PostRepositoryImpl()
        let markBookmarkUsecase = MarkPostAsBookmarkUsecase(repository: repository)
        return PostRelatedViewModel(markPostBookmarkUsecase: markBookmarkUsecase)
    }()
    
    @State var selectedLang: SupportedLang = .vietnamese
    @State private var relatedPostToNavigate: PostDetailResponse?
    @State private var commentText = ""
    @State private var previousLang: SupportedLang = .vietnamese
    @State private var viewModel: PostDetailViewModel
    
    let ns: Namespace.ID?
    
    init(post: PostDetailModel, ns: Namespace.ID? = nil) {
        self.ns = ns
        _viewModel = State(wrappedValue: PostDetailViewModel(post: post))
    }
    
    @State private var isSummaryDialogPresented = false
    @State private var isSummarizing: Bool = false
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        SummaryButtonView(summaryText: $viewModel.sumaryText, isSummarizing: $isSummarizing) {
                            Task {
                                isSummarizing = true
                                await viewModel.loadSummaryText(lang: selectedLang)
                                isSummaryDialogPresented = true
                                isSummarizing = false
                            }
                        }
                        SpeechTestView(selectedLanguage: selectedLang.rawValue, textToSpeech: viewModel.displayingPost.content)
                        BodyPostView(viewModel: viewModel, ns: ns)
                            .id(viewModel.displayingPost.id)
                        CommentsPostView(commentVM: commentsPost)
                        PostRelatedListView(viewModel: postRelatedVM) { selectedPost in
                            relatedPostToNavigate = selectedPost
                        }
                    }
                }
                .scrollIndicators(.hidden)
                Divider()
                CommentInputView(commentText: $commentText, onSend: createComment)
            }
            .padding(.horizontal)
            
            if isSummaryDialogPresented {
                SummaryDialogView(summaryText: viewModel.sumaryText, isPresented: $isSummaryDialogPresented)
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(1)
            }
        }
        .withLoadingOverlay($viewModel.isLoading, message: "Đang tải")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                TranslateToolbarButton(selectedLang: $selectedLang) { lang in
                    Task {
                        await viewModel.translate(to: lang)
                        
                    }
                }
            }
        }
        .task {
            loadData()
            viewModel.isLoading = true
            let detected = await PostDetailViewModel.detectLanguage(of: viewModel.displayingPost.content.htmlToPlainString())
            selectedLang = detected ?? .vietnamese
            viewModel.isLoading = false
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension View {
    @ViewBuilder
    func applyZoomIfNeeded<ID: Hashable>(
        id: ID,
        namespace: Namespace.ID?
    ) -> some View {
        if let namespace {
            self.navigationTransition(
                .zoom(sourceID: id, in: namespace)
            )
        } else {
            self
        }
    }
}

extension PostDetailView {
    private func createComment() {
        Task {
            await commentsPost.createComment(newContent: commentText)
            commentText = ""
        }
    }
    
    private func loadData() {
        Task {
            async let postView:() = commentsPost.getComments(postId: viewModel.displayingPost.id)
            async let postsRelated:() = postRelatedVM.getPostRelated(postId: viewModel.displayingPost.id)
            let (_,_) = try await (postView, postsRelated)
        }
    }
}


struct BodyPostView: View {
    @Bindable var viewModel: PostDetailViewModel
    @State private var selectedImageURL: URL?
    
    let ns: Namespace.ID?
    
    init(
        viewModel: PostDetailViewModel,
        ns: Namespace.ID? = nil
    ) {
        self.viewModel = viewModel
        self.ns = ns
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(viewModel.displayingPost.title)
                .font(.headline)
                .multilineTextAlignment(.leading)
            WebImage(url: viewModel.displayingPost.image) { image in
                image.resizable()
            } placeholder: {
                Rectangle().foregroundColor(.gray)
            }
            .resizable()
            .indicator(.activity)
            .aspectRatio(contentMode: .fit)
            .cornerRadius(8)
            .onTapGesture {
                selectedImageURL = viewModel.displayingPost.image
            }
            .applyZoomIfNeeded(id: viewModel.displayingPost.id, namespace: ns)
            
            Text(viewModel.displayingPost.content.htmlToPlainString())
            
        }
        .navigationDestination(item: $selectedImageURL) { post in
            ImageTranslateView(imageURL: viewModel.displayingPost.image!)
        }
    }
}

import Foundation
import Combine
import NaturalLanguage



struct LoadingOverlayModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Loading...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                }
                .transition(.opacity)
                .animation(.easeInOut, value: isLoading)
            }
        }
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool) -> some View {
        self.modifier(LoadingOverlayModifier(isLoading: isLoading))
    }
}
