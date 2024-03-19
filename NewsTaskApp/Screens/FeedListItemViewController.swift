import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SafariServices

class FeedItemsListViewController: UIViewController, UITableViewDelegate  {
    
    private var viewModel = FeedItemsViewModel()
    private var disposeBag = DisposeBag()
    
    let feedName: String
    let feedUrl: String
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    init(feedName: String, feedUrl: String) {
        self.feedName = feedName
        self.feedUrl = feedUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.getFeeds(feedUrl)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startLoading()
    }
    
    private func setupView() {
        self.title = feedName
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: Strings.Indentifiers.feedItemCell)
        tableView.separatorStyle = .singleLine
    }
    
    private func bindTableView() {
        viewModel.feedResponse.subscribe(onNext: { [weak self] _ in
            self?.stopLoading()
        }).disposed(by: disposeBag)
        
        viewModel.feedResponse.bind(to: tableView.rx.items(cellIdentifier: Strings.Indentifiers.feedItemCell, cellType: FeedItemCell.self)) { row, items, cell in
            cell.configureView(with: items)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(FeedItem.self).subscribe(onNext: { [weak self] item in
            guard let self = self else { return }
            if let urlString = item.link, let url = URL(string: urlString) {
                self.navigationController?.present(SFSafariViewController(url: url), animated: true)
            }
        }).disposed(by: disposeBag)
        
        viewModel.getFeeds(feedUrl)
    }
}

