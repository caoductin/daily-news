//
//  ProfileView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 10/5/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var userVM = UserManager.shared
    @State var email: String = ""
    let defaultImage = ""
    
    var body: some View {
        VStack(spacing: 30) {
            RemoteImageView(imageURl: userVM.currentUser?.profilePicture ?? "", cornerRadius: .infinity)
                .clipShape(Circle())
            VStack(spacing: 8) {
                Text(userVM.currentUser?.username ?? "Undefined")
                Text("Email")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField(email, text: $email)
                    .frame(height: 50)
                    .textFieldStyle(.outline())
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .previewLayout(.sizeThatFits)
                
                Text("Password")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                SecureTextField(password: $email)
                
                Text("Confirm Passwrod")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                SecureTextField(password: $email)
            }
          
            
            Button("Update") {
                
            }
            .buttonStyle(BorderButton(backgroundColor: .blue, cornerRadius: 20))
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
