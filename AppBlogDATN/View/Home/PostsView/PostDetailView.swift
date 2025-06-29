//
//  PostDetailView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 16/5/25.
//

import SwiftUI
import SDWebImageSwiftUI

enum NavigationRoute: Hashable {
    case imageDetail(URL)
    case userProfile(String)
    case settings
}

struct PostDetailView: View {
    @StateObject var commentsPost: CommentViewModel = CommentViewModel()
    @StateObject var postRelatedVM: PostRelatedViewModel = PostRelatedViewModel()
    
    @State var selectedLang: SupportedLang = .vietnamese
    @State private var relatedPostToNavigate: PostDetailResponse?
    @State private var commentText = ""
    @State private var previousLang: SupportedLang = .vietnamese
    @State private var viewModel: PostDetailViewModel
    init(post: PostDetailResponse) {
        _viewModel = State(wrappedValue: PostDetailViewModel(post: post))
    }
    
    @State private var isSummaryDialogPresented = false
    @State private var isSummaryText: Bool = false
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        SummaryButtonView(summaryText: $viewModel.sumaryText, isSummarizing: $isSummaryText) {
                                viewModel.summaryText(to: selectedLang) {
                                    isSummaryDialogPresented = true
                                    isSummaryText = false
                            }
                        }
                        SpeechTestView(selectedLanguage: selectedLang.rawValue, textToSpeech: viewModel.displayingPost.content)
                        BodyPostView(viewModel: viewModel)
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
            print("this is detectTect Language \(detected)")
            viewModel.isLoading = false
            
        }
        //        .navigationDestination(for: NavigationRoute.self, destination: { route in
        //            switch route {
        //            case .imageDetail(let url):
        //                ImageTranslateView(imageURL: url)
        //            default:
        //                Text("không có view nào")
        //            }
        //        })
        .navigationTitle("test")
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let mockPost = PostDetailResponse(
        id: "6824be39121596abb8df7348",
        userId: "user001",
        content: "Liên Hợp Quốc quan ngại về chiến dịch không kích của Mỹ vào Iran.Tôi rất quan ngại về việc Mỹ sử dụng vũ lực chống lại Iran hôm nay.",
        category: "Tech",
        title: "The anniversary ",
        slug: "understanding-swift-concurrency",
        image: "https://www.hostinger.com/tutorials/wp-content/uploads/sites/2/2021/09/how-to-write-a-blog-post.png",
        createdAt: "2025-05-20T10:00:00Z",
        updatedAt: "2025-05-21T09:00:00Z"
    )
    
    let mockPostResponse = PostResponse(
        posts: [mockPost, mockPost],
        totalPosts: 2,
        lastMonthPosts: 1
    )
    let postViewModelMock = PostViewModel()
    NavigationStack {
        PostDetailView(post: mockPost)
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
    var body: some View {
        VStack(alignment: .leading){
            Text(viewModel.displayingPost.title)
                .font(.headline)
                .multilineTextAlignment(.leading)
            if let url = URL(string: viewModel.displayingPost.image) {
                WebImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Rectangle().foregroundColor(.gray)
                }
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .onTapGesture {
                    selectedImageURL = url
                    print()
                }
            }
            Text(viewModel.displayingPost.content.htmlToPlainString())
            
        }
        .navigationDestination(item: $selectedImageURL) { post in
            ImageTranslateView(imageURL: URL(string: viewModel.displayingPost.image)!)
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
