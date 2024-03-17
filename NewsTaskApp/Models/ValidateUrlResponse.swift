import Foundation

struct VaidateUrlResponse: Codable {
    let ok: Bool
    let result: ValidateResult?
    let error: String?
    
    static func parseResponse(data: Data) throws -> VaidateUrlResponse {
        let news = try JSONDecoder().decode(VaidateUrlResponse.self, from: data)
        return news
    }
}

struct ValidateResult: Codable {
    let valid_feed: Bool
    let feed_type: String
}

