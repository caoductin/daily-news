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
            Section(header: Text("Application Information")) {
                HStack {
                    Text("Application Name")
                    Spacer()
                    Text(appName)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Version")
                    Spacer()
                    Text(version)
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("Developer")) {
                HStack {
                    Text("Developer")
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
                    Label("Send email", systemImage: "envelope")
                }
            }

            Section {
                Button {
                    shareApp()
                } label: {
                    Label("📤 Share app", systemImage: "square.and.arrow.up")
                }
            }
        }
        .navigationTitle("ℹ️ Introduction")
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
