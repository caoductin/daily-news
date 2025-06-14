//
//  SegmentPickerView.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/11/25.
//

import SwiftUI

enum Authtab: String, CaseIterable, Identifiable {
    case signIn = "Sign In"
    case signUp = "Sign Up"
    
    var id: String {
        self.rawValue
    }
}

struct TopTab<T: RawRepresentable & Identifiable & CaseIterable >: View where T.RawValue == String {
    @Namespace private var animation
    var tabs: [T]
    @Binding var currentTab: T
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                TabItem(label: tab.rawValue, isSelected: currentTab == tab)
                    .onTapGesture {
                        withAnimation {
                            currentTab = tab
                        }
                    }
            }
        }
        
    }
    
    @ViewBuilder
    func TabItem(label: String, isSelected: Bool) -> some View {
        Text(label)
            .fontWeight(.semibold)
            .lineLimit(1)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .foregroundStyle(isSelected ? .blue : .secondary)
            .overlay(alignment: .bottom){
                if isSelected {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.blue)
                        .frame(height: 4)
                        .matchedGeometryEffect(id: "selection", in: animation)
                        .padding(.horizontal, 16)
                } else {
                    Color.clear
                }
            }
    }
}

struct tesstView : View {
    @State var currentTabIndex = 0
    @State private var currentTab: Authtab = .signIn
    var body: some View {
        TopTab(tabs: Authtab.allCases, currentTab: $currentTab)
        if currentTab == .signIn {
            Text("Sign In View")
        } else {
            Text("Sign Up View")
        }
    }
}

#Preview {
    tesstView()
}

