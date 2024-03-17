import Foundation
import RealmSwift

class FeedObject: Object {
    @objc dynamic var feedName: String = ""
    @objc dynamic var feedUrl: String = ""
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var id: String = ""
    
    convenience init(feedUrl: String, isFavorite: Bool) {
        self.init()
        self.feedName = getNameFromUrl(feedUrl)
        self.feedUrl = feedUrl
        self.isFavorite = isFavorite
        self.id = UUID().uuidString
    }
}

public func getNameFromUrl(_ url: String) -> String {
    var urlString = url
    if let headerRange = urlString.range(of: "://") {
        urlString.removeSubrange(urlString.startIndex..<headerRange.upperBound)
    }
    return urlString.components(separatedBy: "/").first!
}
