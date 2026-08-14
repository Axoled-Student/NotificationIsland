import SwiftUI
import UIKit

@main
struct NotificationIslandApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    static func handleDeepLink(_ url: URL) {
        guard url.scheme == "notificationisland" else { return }

        switch url.host {
        case "line":
            if let appURL = URL(string: "line://") {
                UIApplication.shared.open(appURL, options: [:]) { success in
                    if !success, let webURL = URL(string: "https://line.me/") {
                        UIApplication.shared.open(webURL)
                    }
                }
            }

        case "instagram":
            if let appURL = URL(string: "instagram://app") {
                UIApplication.shared.open(appURL, options: [:]) { success in
                    if !success, let webURL = URL(string: "https://www.instagram.com/") {
                        UIApplication.shared.open(webURL)
                    }
                }
            }

        case "gmail":
            if let appURL = URL(string: "googlegmail://") {
                UIApplication.shared.open(appURL, options: [:]) { success in
                    if !success, let webURL = URL(string: "https://mail.google.com/") {
                        UIApplication.shared.open(webURL)
                    }
                }
            }

        case "messages":
            // sms:// opens Apple's Messages app.
            if let appURL = URL(string: "sms:") {
                UIApplication.shared.open(appURL)
            }

        default:
            break
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "iphone.gen3")
                .font(.system(size: 50))
            Text("Notification Island")
                .font(.title2.bold())
            Text("在「捷徑」中使用「顯示 Dynamic Island 訊息」，即可把文字送到動態島。")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding(30)
        .onOpenURL { url in
            NotificationIslandApp.handleDeepLink(url)
        }
    }
}
