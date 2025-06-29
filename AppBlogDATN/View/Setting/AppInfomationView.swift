//
//  AppInfomationView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 22/6/25.
//

import Foundation
import SwiftUI

struct AppInformationView: View {
    private let appName = "📰 Blog AI"
    private let version = "1.0.0"
    private let developer = "Cao Đức Tin"
    private let contactEmail = "your_email@example.com"
    private let website = "https://yourwebsite.com"

    var body: some View {
        Form {
            Section(header: Text("Thông tin ứng dụng")) {
                HStack {
                    Text("Tên ứng dụng")
                    Spacer()
                    Text(appName)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Phiên bản")
                    Spacer()
                    Text(version)
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Nhà phát triển")) {
                HStack {
                    Text("Người phát triển")
                    Spacer()
                    Text(developer)
                        .foregroundColor(.secondary)
                }

                Link(destination: URL(string: website)!) {
                    Label("Website", systemImage: "globe")
                }

                Button {
                    sendEmail()
                } label: {
                    Label("Gửi email", systemImage: "envelope")
                }
            }

            Section {
                Button {
                    shareApp()
                } label: {
                    Label("📤 Chia sẻ ứng dụng", systemImage: "square.and.arrow.up")
                }
            }
        }
        .navigationTitle("ℹ️ Giới thiệu")
    }

    func sendEmail() {
        let email = "mailto:\(contactEmail)"
        if let url = URL(string: email) {
            UIApplication.shared.open(url)
        }
    }

    func shareApp() {
        guard let url = URL(string: website) else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
