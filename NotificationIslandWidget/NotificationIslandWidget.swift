import WidgetKit
import SwiftUI
import ActivityKit
import UIKit

struct MessageActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var title: String
        var message: String
        var icon: String
    }

    var id: String
}

struct NotificationIslandWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MessageActivityAttributes.self) { context in
            HStack(spacing: 10) {
                notificationIcon(context.state.icon, size: 36)

                VStack(alignment: .leading, spacing: 3) {
                    Text(context.state.title)
                        .font(.headline)
                        .lineLimit(1)
                    Text(context.state.message)
                        .font(.body)
                        .lineLimit(3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    notificationIcon(context.state.icon, size: 34)
                        .padding(.leading, 6)
                }

                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.title)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 8)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.message)
                        .font(.body)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.bottom, 4)
                }
            } compactLeading: {
                notificationIcon(context.state.icon, size: 18)
            } compactTrailing: {
                Text(context.state.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: 72)
            } minimal: {
                notificationIcon(context.state.icon, size: 18)
            }
            .widgetURL(deepLink(for: context.state.icon))
        }
    }

    @ViewBuilder
    private func notificationIcon(_ icon: String, size: CGFloat) -> some View {
        let imageName = resourceName(for: icon)
        if let image = UIImage(named: imageName, in: Bundle.main, compatibleWith: nil) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: size * 0.22))
                .accessibilityLabel(imageName)
        } else {
            Image(systemName: "message.fill")
                .font(.system(size: size * 0.72))
                .frame(width: size, height: size)
        }
    }

    private func resourceName(for icon: String) -> String {
        switch icon {
        case "instagram": return "Instagram"
        case "gmail": return "Gmail"
        case "messages": return "Messages"
        case "retro": return "Retro"
        case "pikminBloom": return "PikminBloom"
        case "duolingo": return "Duolingo"
        case "investment": return "Investment"
        case "taishin": return "Taishin"
        case "stressWatch": return "StressWatch"
        default: return "LINE"
        }
    }

    private func deepLink(for icon: String) -> URL? {
        switch icon {
        case "instagram": return URL(string: "notificationisland://instagram")
        case "gmail": return URL(string: "notificationisland://gmail")
        case "messages": return URL(string: "notificationisland://messages")
        case "retro": return URL(string: "notificationisland://retro")
        case "pikminBloom": return URL(string: "notificationisland://pikminBloom")
        case "duolingo": return URL(string: "notificationisland://duolingo")
        case "investment": return URL(string: "notificationisland://investment")
        case "taishin": return URL(string: "notificationisland://taishin")
        case "stressWatch": return URL(string: "notificationisland://stressWatch")
        default: return URL(string: "notificationisland://line")
        }
    }
}
