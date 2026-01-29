
import SwiftUI

struct SearchView: View {
    @Environment(SearchCoordinator.self) private var searchCoordinates
    @Environment(PostStore.self) private var postStore
    @State var viewModel: SearchViewModel
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 12) {
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                
                TextField("Search posts...", text: $viewModel.query)
                    .textFieldStyle(.plain)
                    .submitLabel(.search)
                    .onSubmit {
                        Task { await viewModel.search() }
                    }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3))
            )
            .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 20)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            List(viewModel.postIds, id: \.self) { id in
                if let post = postStore.post(id: id) {
                    PostSearchRow(
                        post: post,
                        onSelected: { post in
                            searchCoordinates.push(.postDetail(post))
                        },
                        onToggleBookmark: {
                            Task {
                                await viewModel.toggleBookmark(postId: post.id)
                            }
                        },
                        ns: animation
                    )
                }
            }
            .navigationTitle("Search")
        }
    }
}

struct PostSearchRow: View {
    let post: PostDetailModel
    let onSelected: (PostDetailModel) -> Void
    let onToggleBookmark: () -> Void
    let ns: Namespace.ID
    
    var body: some View {
        ArticleCardView(
            post: post,
            onToggleBookmark: onToggleBookmark
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onSelected(post)
        }
        .navigationTransition(.zoom(sourceID: post.id, in: ns))
        .modifier(PressedScale(scale: 0.94))
    }
}
