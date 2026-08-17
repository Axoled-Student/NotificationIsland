import Foundation
import ActivityKit

struct MessageActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var title: String
        var message: String
        var icon: String
        var tick: Int
    }

    var id: String
}
