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
    static var description = IntentDescription("顯示 Dynamic Island 訊息，可用秒與毫秒自訂顯示時間。")
    static var openAppWhenRun: Bool = false

    private static let minimumDisplayMilliseconds = 1
    private static let maximumDisplayMilliseconds = 25_000

    @Parameter(title: "標題")
    var titleText: String

    @Parameter(title: "訊息")
    var message: String

    @Parameter(title: "圖示")
    var icon: NotificationIcon

    @Parameter(
        title: "顯示時間（秒）",
        description: "秒數，可設定 0 到 25 秒。",
        default: 5,
        inclusiveRange: 0...25
    )
    var displaySeconds: Int

    @Parameter(
        title: "顯示時間（毫秒）",
        description: "額外毫秒數，可設定 0 到 999 ms。例如 0 秒 + 500 ms = 500 ms。",
        default: 0,
        inclusiveRange: 0...999
    )
    var displayMilliseconds: Int

    init() {
        self.icon = .line
        self.displaySeconds = 5
        self.displayMilliseconds = 0
    }

    init(
        titleText: String,
        message: String,
        icon: NotificationIcon = .line,
        displaySeconds: Int = 5,
        displayMilliseconds: Int = 0
    ) {
        self.titleText = titleText
        self.message = message
        self.icon = icon
        self.displaySeconds = displaySeconds
        self.displayMilliseconds = displayMilliseconds
    }

    func perform() async throws -> some IntentResult {
        let safeTitle = String(titleText.prefix(80))
        let safeMessage = String(message.prefix(300))
        let requestedDisplayMilliseconds =
            (displaySeconds * 1_000) + displayMilliseconds
        let boundedDisplayMilliseconds = min(
            max(requestedDisplayMilliseconds, Self.minimumDisplayMilliseconds),
            Self.maximumDisplayMilliseconds
        )
        let expiryDate = Date().addingTimeInterval(
            Double(boundedDisplayMilliseconds) / 1_000.0
        )

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

        try? await Task.sleep(for: .milliseconds(boundedDisplayMilliseconds))

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
