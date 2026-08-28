import AppIntents
import ActivityKit

enum NotificationIcon: String, AppEnum {
    case line
    case instagram
    case gmail
    case messages
    case retro
    case pikminBloom
    case duolingo
    case investment
    case taishin
    case stressWatch
    case reddit

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "通知圖示")
    }

    static var caseDisplayRepresentations: [NotificationIcon: DisplayRepresentation] {
        [
            .line: DisplayRepresentation(title: "LINE"),
            .instagram: DisplayRepresentation(title: "Instagram"),
            .gmail: DisplayRepresentation(title: "Gmail"),
            .messages: DisplayRepresentation(title: "訊息"),
            .retro: DisplayRepresentation(title: "Retro"),
            .pikminBloom: DisplayRepresentation(title: "Pikmin Bloom"),
            .duolingo: DisplayRepresentation(title: "Duolingo"),
            .investment: DisplayRepresentation(title: "投資先生"),
            .taishin: DisplayRepresentation(title: "台新銀行"),
            .stressWatch: DisplayRepresentation(title: "StressWatch"),
            .reddit: DisplayRepresentation(title: "Reddit")
        ]
    }
}

struct ShowMessageIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "顯示 Dynamic Island 訊息"
    static var description = IntentDescription("顯示 Dynamic Island 訊息，可自訂顯示 1 到 25 秒。")
    static var openAppWhenRun: Bool = false

    private static let minimumDisplaySeconds = 1
    private static let maximumDisplaySeconds = 25

    @Parameter(title: "標題")
    var titleText: String

    @Parameter(title: "訊息")
    var message: String

    @Parameter(title: "圖示")
    var icon: NotificationIcon

    @Parameter(
        title: "顯示時間（秒）",
        description: "Dynamic Island 顯示時間。可設定 1 到 25 秒；實際顯示仍由 iOS 系統控制。",
        default: 5,
        inclusiveRange: 1...25
    )
    var displaySeconds: Int

    init() {
        self.icon = .line
        self.displaySeconds = 5
    }

    init(
        titleText: String,
        message: String,
        icon: NotificationIcon = .line,
        displaySeconds: Int = 5
    ) {
        self.titleText = titleText
        self.message = message
        self.icon = icon
        self.displaySeconds = displaySeconds
    }

    func perform() async throws -> some IntentResult {
        let safeTitle = String(titleText.prefix(80))
        let safeMessage = String(message.prefix(300))
        let boundedDisplaySeconds = min(
            max(displaySeconds, Self.minimumDisplaySeconds),
            Self.maximumDisplaySeconds
        )
        let expiryDate = Date().addingTimeInterval(TimeInterval(boundedDisplaySeconds))

        let attributes = MessageActivityAttributes(id: UUID().uuidString)
        let state = MessageActivityAttributes.ContentState(
            title: safeTitle,
            message: safeMessage,
            icon: icon.rawValue,
            tick: 0
        )

        for old in Activity<MessageActivityAttributes>.activities {
            let oldContent = ActivityContent(
                state: old.content.state,
                staleDate: nil
            )
            await old.end(
                oldContent,
                dismissalPolicy: ActivityUIDismissalPolicy.immediate
            )
        }

        let activity = try Activity.request(
            attributes: attributes,
            content: ActivityContent(
                state: state,
                staleDate: expiryDate,
                relevanceScore: 100
            ),
            pushType: nil,
            style: .transient
        )

        try? await Task.sleep(for: .seconds(boundedDisplaySeconds))

        await activity.end(
            ActivityContent(
                state: state,
                staleDate: nil
            ),
            dismissalPolicy: ActivityUIDismissalPolicy.immediate
        )

        return .result()
    }
}
