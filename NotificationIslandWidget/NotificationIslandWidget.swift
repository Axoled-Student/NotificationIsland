import WidgetKit
import SwiftUI
import ActivityKit
import UIKit

struct MessageActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var title: String
        var message: String
        var icon: String
        var customIconData: Data?
        var tick: Int
    }

    var id: String
}

struct NotificationIslandWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MessageActivityAttributes.self) { context in
            HStack(spacing: 10) {
                notificationIcon(
                    presetIcon: context.state.icon,
                    customIconData: context.state.customIconData,
                    size: 36
                )

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
                    VStack {
                        Spacer(minLength: 0)
                        notificationIcon(
                            presetIcon: context.state.icon,
                            customIconData: context.state.customIconData,
                            size: 42
                        )
                        Spacer(minLength: 0)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                    .padding(.leading, hasAnyIcon(context.state) ? 8 : 0)
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.state.title)
                            .font(.headline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)

                        Text(context.state.message)
                            .font(.subheadline)
                            .lineLimit(2)
                            .minimumScaleFactor(0.72)
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    if let displayName = appDisplayName(for: context.state.icon) {
                        Text(displayName)
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.65)
                            .frame(maxWidth: 76, alignment: .trailing)
                            .padding(.trailing, 6)
                    }
                }
            } compactLeading: {
                notificationIcon(
                    presetIcon: context.state.icon,
                    customIconData: context.state.customIconData,
                    size: 18
                )
            } compactTrailing: {
                Text(context.state.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: 72)
            } minimal: {
                notificationIcon(
                    presetIcon: context.state.icon,
                    customIconData: context.state.customIconData,
                    size: 18
                )
            }
            .widgetURL(deepLink(for: context.state.icon))
        }
    }

    private func hasAnyIcon(_ state: MessageActivityAttributes.ContentState) -> Bool {
        if let data = state.customIconData, UIImage(data: data) != nil {
            return true
        }
        return resourceName(for: state.icon) != nil
    }

    @ViewBuilder
    private func notificationIcon(
        presetIcon: String,
        customIconData: Data?,
        size: CGFloat
    ) -> some View {
        if let customIconData,
           let image = UIImage(data: customIconData) {
            iconImage(image, size: size, accessibilityLabel: "自訂圖示")
        } else if let imageName = resourceName(for: presetIcon),
                  let image = UIImage(named: imageName, in: Bundle.main, compatibleWith: nil) {
            iconImage(image, size: size, accessibilityLabel: imageName)
        } else if !presetIcon.isEmpty {
            Image(systemName: "message.fill")
                .font(.system(size: size * 0.72))
                .frame(width: size, height: size)
        }
    }

    private func iconImage(
        _ image: UIImage,
        size: CGFloat,
        accessibilityLabel: String
    ) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.22))
            .accessibilityLabel(accessibilityLabel)
    }

    private func resourceName(for icon: String) -> String? {
        switch icon {
        case "line": return "LINE"
        case "instagram": return "Instagram"
        case "gmail": return "Gmail"
        case "messages": return "Messages"
        case "retro": return "Retro"
        case "pikminBloom": return "PikminBloom"
        case "duolingo": return "Duolingo"
        case "investment": return "Investment"
        case "taishin": return "Taishin"
        case "stressWatch": return "StressWatch"
        case "reddit": return "Reddit"
        default: return nil
        }
    }

    private func appDisplayName(for icon: String) -> String? {
        switch icon {
        case "line": return "LINE"
        case "instagram": return "Instagram"
        case "gmail": return "Gmail"
        case "messages": return "訊息"
        case "retro": return "Retro"
        case "pikminBloom": return "Pikmin Bloom"
        case "duolingo": return "Duolingo"
        case "investment": return "投資先生"
        case "taishin": return "台新銀行"
        case "stressWatch": return "StressWatch"
        case "reddit": return "Reddit"
        default: return nil
        }
    }

    private func deepLink(for icon: String) -> URL? {
        switch icon {
        case "line": return URL(string: "line://")
        case "instagram": return URL(string: "instagram://")
        case "gmail": return URL(string: "gmail://")
        case "messages": return URL(string: "messages://")
        case "retro": return URL(string: "retro://")
        case "pikminBloom": return URL(string: "pikminbloom://")
        case "duolingo": return URL(string: "duolingo://")
        case "investment": return URL(string: "investment://")
        case "taishin": return URL(string: "taishin://")
        case "stressWatch": return URL(string: "stresswatch://")
        case "reddit": return URL(string: "reddit://")
        default: return nil
        }
    }
}
