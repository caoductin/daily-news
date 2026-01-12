//
//  ViewExtension.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 14/6/25.
//
import SwiftUI

extension View {
    func confirmDeleteAlert(
        isPresented: Binding<Bool>,
        item: Binding<CommentResponse?>,
        onDelete: @escaping (CommentResponse) -> Void
    ) -> some View {
        alert("Are you sure you want to delete the comment?", isPresented: isPresented, presenting: item.wrappedValue) { comment in
            Button("Delete", role: .destructive) {
                onDelete(comment)
            }
            Button("Cancel", role: .cancel) {}
        } message: { comment in
            Text("\"\(comment.content.prefix(40))...\" It will be permanently deleted.")
        }
    }
}

extension View {
    func navigate<Item: Identifiable, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        self
            .background(
                NavigationLink(
                    destination: item.wrappedValue.map { destination($0) },
                    isActive: Binding(
                        get: { item.wrappedValue != nil },
                        set: { if !$0 { item.wrappedValue = nil } }
                    ),
                    label: { EmptyView() }
                )
                .hidden()
            )
    }
}
