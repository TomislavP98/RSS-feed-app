import Foundation

struct FeedResponse: Codable {
    let ok: Bool
    let result: ResponseValue
    
    static func parseResponse(data: Data) throws -> FeedResponse {
        let news = try JSONDecoder().decode(FeedResponse.self, from: data)
        return news
    }
}

struct ResponseValue: Codable {
    let info: Feed
    let entries: [FeedItem]
}

struct Feed: Codable {
    let title, description: String
    let homepage: String
    let feed_url: String
}

struct FeedItem: Codable {
    let title: String
    let link: String
    let description: String
    let image: Image
    let time: String
}

struct Image: Codable {
    let url: String?
    let width, height: Int?
}
