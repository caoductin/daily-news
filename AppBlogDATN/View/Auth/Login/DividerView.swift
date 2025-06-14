//
//  DividerView.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/10/25.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        HStack {
            Divider()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.3))
                .frame(height: 0.5)
            
            Text("Or")
            
            Divider()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.3))
                .frame(height: 0.5)
        }
    }
}

#Preview {
    DividerView()
}
