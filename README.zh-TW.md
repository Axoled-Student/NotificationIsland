# NotificationIsland
<img width="500" height="360" alt="808422338 946440" src="https://github.com/user-attachments/assets/44865a10-4e10-4e5c-b67d-d1fe8e9c9745" />
<img width="500" height="360" alt="808422338 893899" src="https://github.com/user-attachments/assets/d20cbafa-9b03-4aa1-966b-f21f2b786641" />


> 在 iPhone Dynamic Island 上顯示自訂訊息的 iOS Live Activity 專案。

NotificationIsland 是一個以 **SwiftUI、ActivityKit、WidgetKit、App Intents** 製作的實驗性專案。

你可以從「捷徑」自動化執行 App Intent，把標題、訊息與 App 圖示顯示到 Dynamic Island。

> **iOS 27 Beta 5+ 相容性：** Live Activity 已改用 ActivityKit 官方支援的 transient 顯示方式，不再依賴持續送出靜默更新來維持展開。設計目標包含 iOS 27 Beta 5、Beta 6、Beta 7 與後續 iOS 27 版本；實際 Dynamic Island 顯示時間仍由 iOS 控制。

## ✨ 目前功能

### Dynamic Island

執行捷徑中的：

**「顯示 Dynamic Island 訊息」**

即可顯示：

- 通知標題
- 通知訊息
- 選擇 App 圖示
- 使用 **秒 + 毫秒**自訂顯示時間（預設 5 秒 + 0 ms，總時間最多 25 秒）

捷徑會分別提供 **秒（0–25）**與 **毫秒（0–999）**欄位。例如 `0 秒 + 500 ms` 代表 500 ms，`2 秒 + 250 ms` 代表 2.25 秒，總時間最多 25 秒。App 會要求 transient Live Activity，讓 iOS 使用展開的 Dynamic Island 顯示；如果使用者收合 Dynamic Island、鎖定裝置或離開互動情境，iOS 仍可能提早結束。

### App 圖示

目前可以在捷徑中選擇：

| 圖示 | App |
|---|---|
| 🟢 | LINE |
| 🟣 | Instagram |
| 📧 | Gmail |
| 💬 | 訊息 |
| 🪩 | Retro |
| 🌱 | Pikmin Bloom |
| 🦉 | Duolingo |
| 📈 | 投資先生 |
| 🏦 | 台新銀行 |
| 💚 | StressWatch |

圖示會顯示在 Dynamic Island 中，用來模擬對應 App 的通知外觀。

### 點擊 Dynamic Island

目前點擊 Dynamic Island 會先開啟 **NotificationIsland**，再依照所選圖示嘗試跳轉到對應 App。

不同 App 的 URL Scheme、Universal Link 或 iOS 系統限制可能造成跳轉行為不同。

## 🔗 捷徑

https://www.icloud.com/shortcuts/022b6230e2f149198026cb6d905cfaa1

## 📱 系統需求

- **iOS 27 Beta 5 或後續 iOS 27 beta／版本**
- 支援 Dynamic Island 的 iPhone
- Apple Developer 帳號（自行簽署／側載時使用）
- Windows 使用者可以使用 GitHub Actions 建立 unsigned IPA，再透過 Sideloadly、iLoader 等工具自行簽署安裝

> 本專案目前採用公開 ActivityKit 行為來支援 **iOS 27 Beta 5+**；Apple 後續 beta 仍可能調整實際 Dynamic Island 顯示行為。

## 📲 安裝 unsigned IPA

GitHub Actions 產生的是 **unsigned IPA**，不能直接當成一般 App 安裝。

需要使用自己的 Apple ID 及簽署工具，例如：

- Sideloadly
- iLoader
- 其他合法的 iOS 側載／簽署工具

使用免費 Apple Developer 帳號時，App 的簽署期限及 App ID 數量等限制由 Apple 的開發者機制決定。

### Windows 使用者

本專案可以在 Windows 上開發，並使用 **GitHub Actions 的 macOS Runner** 建立 unsigned IPA。

```text
Windows
  ↓
GitHub
  ↓
GitHub Actions / macOS Runner
  ↓
unsigned IPA
  ↓
Sideloadly / iLoader
  ↓
iPhone
```

## ⚠️ 目前限制

這是一個實驗性專案，並不是 LINE、Instagram、Gmail、Apple、Retro、Pikmin Bloom、Duolingo、投資先生、台新銀行或 StressWatch 官方推出的通知工具。

目前的 App 圖示只是用來模擬不同 App 的通知外觀。

本專案**不能直接讀取 LINE、Instagram、Gmail、Apple 訊息或其他第三方 App 的私有系統通知內容**。

目前的使用方式是：

```text
捷徑
 ↓
NotificationIsland
 ↓
Live Activity
 ↓
Dynamic Island
```

而不是：

```text
LINE / Instagram / Gmail 等 App 收到真正通知
 ↓
NotificationIsland 自動讀取通知
 ↓
Dynamic Island
```

後者需要 iOS 系統允許的通知／自動化機制，不能單純靠一般 App 的 App Intent 直接讀取其他 App 的私有通知資料。

## 🛠️ 技術

- Swift
- SwiftUI
- ActivityKit
- WidgetKit
- App Intents
- Shortcuts
- Live Activities

## ⭐ Credits

本專案主要使用 Apple 提供的 ActivityKit、WidgetKit、App Intents、SwiftUI 與 Shortcuts / App Intents 製作。

## 💖 贊助支援 (Sponsor)

如果您覺得這個專案對您有幫助，歡迎透過加密貨幣贊助支持開發！

### Polygon (POL / ERC-20 Tokens)

<img width="398" height="581" alt="螢幕擷取畫面 2026-08-14 012349" src="https://github.com/user-attachments/assets/368d656f-d51c-4714-add6-82beac285763" />

- **Network:** Polygon (POS)
- **Address:** `0xFe8F7ae9526C9dE0CF4E793d4b313340c105E3Be`
