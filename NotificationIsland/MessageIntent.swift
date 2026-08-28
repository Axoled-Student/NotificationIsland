import AppIntents
import ActivityKit
import UIKit
import UniformTypeIdentifiers

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
    static var description = IntentDescription("顯示 Dynamic Island 訊息，可選擇內建圖示、自訂圖示或不顯示圖示。")
    static var openAppWhenRun: Bool = false

    private static let minimumDisplayMilliseconds = 1
    private static let maximumDisplayMilliseconds = 25_000
    private static let maximumEncodedActivityBytes = 3_500

    @Parameter(title: "標題")
    var titleText: String

    @Parameter(title: "訊息")
    var message: String

    @Parameter(
        title: "圖示",
        description: "可選擇內建 App 圖示。留空時不會自動顯示 LINE。"
    )
    var icon: NotificationIcon?

    @Parameter(
        title: "自訂圖示",
        description: "可從照片、檔案或上一個捷徑動作傳入圖片。自訂圖示會優先於內建圖示。",
        supportedContentTypes: [.image]
    )
    var customIcon: IntentFile?

    @Parameter(
        title: "顯示時間（秒）",
        description: "秒數，可設定 0 到 25 秒。",
        default: 5,
        inclusiveRange: (lowerBound: 0, upperBound: 25)
    )
    var displaySeconds: Int

    @Parameter(
        title: "顯示時間（毫秒）",
        description: "額外毫秒數，可設定 0 到 999 ms。例如 0 秒 + 500 ms = 500 ms。",
        default: 0,
        inclusiveRange: (lowerBound: 0, upperBound: 999)
    )
    var displayMilliseconds: Int

    init() {
        self.icon = nil
        self.customIcon = nil
        self.displaySeconds = 5
        self.displayMilliseconds = 0
    }

    init(
        titleText: String,
        message: String,
        icon: NotificationIcon? = nil,
        customIcon: IntentFile? = nil,
        displaySeconds: Int = 5,
        displayMilliseconds: Int = 0
    ) {
        self.titleText = titleText
        self.message = message
        self.icon = icon
        self.customIcon = customIcon
        self.displaySeconds = displaySeconds
        self.displayMilliseconds = displayMilliseconds
    }

    func perform() async throws -> some IntentResult {
        let safeTitle = String(titleText.prefix(80))
        let safeMessage = String(message.prefix(300))
        let presetIcon = icon?.rawValue ?? ""

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
        let customIconData = makeCustomIconData(
            from: customIcon,
            attributes: attributes,
            title: safeTitle,
            message: safeMessage,
            presetIcon: presetIcon
        )

        let state = MessageActivityAttributes.ContentState(
            title: safeTitle,
            message: safeMessage,
            icon: presetIcon,
            customIconData: customIconData,
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

    private func makeCustomIconData(
        from file: IntentFile?,
        attributes: MessageActivityAttributes,
        title: String,
        message: String,
        presetIcon: String
    ) -> Data? {
        guard let file,
              let sourceImage = UIImage(data: file.data) else {
            return nil
        }

        // ActivityKit limits the combined static + dynamic Live Activity data
        // to 4 KB. Try progressively smaller PNG/JPEG versions and keep the
        // first candidate that leaves additional headroom for ActivityKit.
        let sides: [CGFloat] = [48, 42, 36, 32, 28, 24, 20]

        for side in sides {
            let transparentImage = squareCrop(sourceImage, side: side, opaque: false)
            if let pngData = transparentImage.pngData(),
               activityPayloadFits(
                    customIconData: pngData,
                    attributes: attributes,
                    title: title,
                    message: message,
                    presetIcon: presetIcon
               ) {
                return pngData
            }

            let opaqueImage = squareCrop(sourceImage, side: side, opaque: true)
            for quality: CGFloat in [0.80, 0.65, 0.50, 0.35, 0.20] {
                if let jpegData = opaqueImage.jpegData(compressionQuality: quality),
                   activityPayloadFits(
                        customIconData: jpegData,
                        attributes: attributes,
                        title: title,
                        message: message,
                        presetIcon: presetIcon
                   ) {
                    return jpegData
                }
            }
        }

        // If the image still can't fit inside ActivityKit's payload budget,
        // omit only the custom icon instead of failing the whole Live Activity.
        return nil
    }

    private func squareCrop(
        _ image: UIImage,
        side: CGFloat,
        opaque: Bool
    ) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = opaque

        let renderer = UIGraphicsImageRenderer(
            size: CGSize(width: side, height: side),
            format: format
        )

        return renderer.image { context in
            if opaque {
                context.cgContext.setFillColor(UIColor.white.cgColor)
                context.cgContext.fill(CGRect(x: 0, y: 0, width: side, height: side))
            }

            let imageSize = image.size
            guard imageSize.width > 0, imageSize.height > 0 else { return }

            let scale = max(side / imageSize.width, side / imageSize.height)
            let drawWidth = imageSize.width * scale
            let drawHeight = imageSize.height * scale
            let drawRect = CGRect(
                x: (side - drawWidth) / 2,
                y: (side - drawHeight) / 2,
                width: drawWidth,
                height: drawHeight
            )

            image.draw(in: drawRect)
        }
    }

    private func activityPayloadFits(
        customIconData: Data,
        attributes: MessageActivityAttributes,
        title: String,
        message: String,
        presetIcon: String
    ) -> Bool {
        let candidateState = MessageActivityAttributes.ContentState(
            title: title,
            message: message,
            icon: presetIcon,
            customIconData: customIconData,
            tick: 0
        )

        guard let encodedAttributes = try? JSONEncoder().encode(attributes),
              let encodedState = try? JSONEncoder().encode(candidateState) else {
            return false
        }

        return encodedAttributes.count + encodedState.count <= Self.maximumEncodedActivityBytes
    }
}
