import Foundation
import Moya
import RxMoya
import RxSwift

class FeedItemsViewModel {
    
    private let service: MoyaProvider<MoyaService>
    private var disposeBag = DisposeBag()
    var feedResponse = BehaviorSubject<[FeedItem]>(value: [])
    
    init(service: MoyaProvider<MoyaService> = MoyaProvider<MoyaService>()) {
        self.service = service
    }
    
    func getFeeds(_ url: String) {
        service.rx.request(.getUser(url: url)).subscribe { [weak self] event in
            switch event {
            case let .success(response):
                do {
                    let filterResponse = try response.filterSuccessfulStatusCodes()
                    let feedResponse = try filterResponse.map(FeedResponse.self,using: JSONDecoder())
                    self?.feedResponse.onNext(feedResponse.result.entries)
                } catch let error {
                    self?.feedResponse.onNext([])
                    print(error.localizedDescription)
                }
            case .failure(let error):
                self?.feedResponse.onNext([])
                print(error.localizedDescription)
            }
        }.disposed(by: disposeBag)
    }
}
