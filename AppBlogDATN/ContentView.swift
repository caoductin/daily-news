//
//  ContentView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import SwiftUI

struct ContentView: View {
    var action: (() -> ())?
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: {
                action?()
            }) {
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(action: {
        print("cao duc tin")
    })
}
