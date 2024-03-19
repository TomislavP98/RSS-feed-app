import RxSwift
import Moya
import RxMoya
import Foundation

class FeedsListViewModel {
    
    private var databaseManager = RealmManager()
    let feedResponse = BehaviorSubject<[FeedObject]>(value: [])
    private let service: MoyaProvider<MoyaService>
    private var disposeBag = DisposeBag()
    var validationResponse = PublishSubject<Bool>()
    
    init(service: MoyaProvider<MoyaService> = MoyaProvider<MoyaService>()) {
        self.service = service
    }
    
    func validateAndCreateFeed(url: String, screenType: ScreenTypes) {
        service.rx.request(.verifyUrl(url: url)).subscribe { [weak self] event in
            switch event {
            case let .success(response):
                do {
                    let filterResponse = try response.filterSuccessfulStatusCodes()
                    let validationResponse = try filterResponse.map(VaidateUrlResponse.self,using: JSONDecoder())
                    if let result = validationResponse.result, result.valid_feed {
                        self?.createFeed(object: FeedObject(feedUrl: url, isFavorite: screenType == ScreenTypes.favoriteFeedsScreen), screenType: screenType)
                    } else {
                        self?.validationResponse.onNext(false)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    self?.validationResponse.onNext(false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.validationResponse.onNext(false)
            }
        }.disposed(by: disposeBag)
    }

    
    func getFeedsList(screenType: ScreenTypes) {
        if screenType == .allFeedsScreen{
            self.feedResponse.onNext(databaseManager.fetchAllFeeds())
        } else {
            self.feedResponse.onNext(databaseManager.fetchFavoriteFeeds())
        }
    }
        
    func removeFeed(url: String, screenType: ScreenTypes) {
        self.databaseManager.deleteObjectFromRealm(url: url)
        self.getFeedsList(screenType: screenType)
    }
    
    func toggleFeedFavorite(id: String, screenType: ScreenTypes) {
        self.databaseManager.toggleFavorite(id: id)
        self.getFeedsList(screenType: screenType)
    }
    
    func createFeed(object: FeedObject, screenType: ScreenTypes) {
        self.databaseManager.addObjectToRealm(object)
        self.getFeedsList(screenType: screenType)
    }
}
