import KeychainSwift
import Foundation
import Moya

let keychain = KeychainSwift()

enum MoyaService : TargetType {
   
    var baseURL: URL { return URL(string: "https://api.rssapi.net")! }
    
    case getUser(url: String)
    case verifyUrl(url: String)
    
    var path: String {
        guard let secret = keychain.get(Strings.Key.apiKey) else { return ""}
        switch self {
        case .getUser:
            return "/v1/" + secret + "/get"
        case .verifyUrl:
            return "/v1/" + secret + "/validate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser, .verifyUrl:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUser(let url), .verifyUrl(let url):
            return .requestParameters(parameters: ["url" : url], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUser, .verifyUrl:
            return ["Content-type" : "application/json"]
        }
    }
}

private extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
