//
//  WelcomeView.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/10/25.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        VStack(spacing: 24) {
            VStack {
                Text("Your Email")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Enter your email", text: $username)
                    .frame(height: 50)
                    .textFieldStyle(.outline())
                    .autocorrectionDisabled()
                    .previewLayout(.sizeThatFits)
                
                Text("Password")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                SecureTextField()
            }
               
                Button("Continue") {
                    
                }.buttonStyle(BorderButton.style(backgroundColor: .primaryColor, cornerRadius: 10))
           
            
            DividerView()
            VStack(spacing: 10) {
                FooterLoginView()
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}

struct BorderButton: ButtonStyle {
    var backgroundColor: Color
    var cornerRadius: CGFloat = 8
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(backgroundColor)
            )
    }
    
    static func style(backgroundColor: Color = .blue, cornerRadius: CGFloat = 8) -> BorderButton {
        BorderButton(backgroundColor: backgroundColor, cornerRadius: cornerRadius)
    }
    
}
//struct PageView: View {
//    @State private var currentPage = 0
//
//    var body: some View {
//        VStack {
//            TabView(selection: $currentPage) {
//                Text("Sign In Page")
//                    .font(.largeTitle)
//                    .tag(0)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color.blue.opacity(0.3))
//
//                Text("Sign Up Page")
//                    .font(.largeTitle)
//                    .tag(1)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color.green.opacity(0.3))
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Ẩn dot indicator
//
//            HStack(spacing: 20) {
//                Button("Sign In") {
//                    currentPage = 0
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//
//                Button("Sign Up") {
//                    currentPage = 1
//                }
//                .padding()
//                .background(Color.green)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    PageView()
//}

