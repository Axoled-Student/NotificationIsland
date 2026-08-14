# NotificationIsland

> 在 iPhone Dynamic Island 上顯示自訂訊息的 iOS Live Activity 小工具。

NotificationIsland 是一個以 **SwiftUI、ActivityKit、WidgetKit、App Intents** 製作的實驗性專案。
你可以從「捷徑」自動化執行 App Intent，把標題、訊息與 App 圖示顯示到 Dynamic Island，推薦把原生通知的**橫幅**關掉。

目前支援：

- 🟢 LINE
- 🟣 Instagram
- 📧 Gmail
- 💬 訊息
## 捷徑連結
https://www.icloud.com/shortcuts/022b6230e2f149198026cb6d905cfaa1
---
## ✨ 目前功能

### Dynamic Island

執行捷徑中的：

**「顯示 Dynamic Island 訊息」**

即可顯示：

- 通知標題
- 通知訊息
- 選擇 App 圖示

目前 Live Activity 會在啟動後約 **5 秒自動結束**。

### App 圖示

捷徑中可以選擇：

| 圖示 | App |
|---|---|
| 🟢 | LINE |
| 🟣 | Instagram |
| 📧 | Gmail |
| 💬 | 訊息 |

圖示會直接顯示在 Dynamic Island。

### 點擊 Dynamic Island

目前點擊 Dynamic Island 會先開啟 NotificationIsland，再依照所選圖示跳轉到對應 App。

不同 App 的 URL Scheme / 系統限制可能造成跳轉行為不同。

---

## 📱 系統需求

- iOS 27 beta 5
- 支援 Dynamic Island 的 iPhone
- Apple Developer 帳號（自行簽署／側載時使用）
- Windows 使用者可以使用 GitHub Actions 建立 unsigned IPA，再透過 Sideloadly、iLoader 等工具自行簽署安裝


---

## 📲 安裝 unsigned IPA

GitHub Actions 產生的是 **unsigned IPA**，不能直接當成一般 App 安裝。

需要使用自己的 Apple ID 及簽署工具，例如：

- Sideloadly
- iLoader
- 其他合法的 iOS 側載／簽署工具

使用免費 Apple Developer 帳號時，App 的簽署期限及 App ID 數量等限制由 Apple 的開發者機制決定。


---

## ⚠️ 目前限制

這是一個實驗性專案，並不是 LINE、Instagram、Gmail 或 Apple 官方推出的通知工具。

目前的 App 圖示只是用來模擬不同 App 的通知外觀。

本專案**目前還不能直接讀取 LINE、Instagram、Gmail 或 Apple 訊息的系統通知內容**。

也就是：

```text
目前：
捷徑
 ↓
NotificationIsland
 ↓
Dynamic Island
```

而不是：

```text
LINE 收到真正通知
 ↓
NotificationIsland 自動讀取通知
 ↓
Dynamic Island
```

後者需要 iOS 系統允許的通知／自動化機制，不能單純靠一般 App 的 App Intent 直接讀取其他 App 的私有通知資料。


---

## ⭐ Credits

本專案主要使用 Apple 提供的：

- ActivityKit
- WidgetKit
- AppIntents
- SwiftUI
- Shortcuts / App Intents

製作。

## 💖 贊助支援 (Sponsor)

如果您覺得這個專案對您有幫助，歡迎透過加密貨幣贊助支持開發！

### Polygon (POL / ERC-20 Tokens)

<img width="398" height="581" alt="螢幕擷取畫面 2026-08-14 012349" src="https://github.com/user-attachments/assets/14893ced-5ded-4ba5-bba4-9c88125b43e3" />

* **Network:** Polygon (POS)
* **Address:** `0xFe8F7ae9526C9dE0CF4E793d4b313340c105E3Be`

> ⚠️ **注意：** 請務必確認轉帳網路為 **Polygon**，切勿使用其他主網轉入以避免資產遺失。
