import UIKit
import SnapKit
import RxSwift
import RxCocoa
import KeychainSwift

class FeedsListViewController: UIViewController, UITableViewDelegate  {
    
    private var viewModel = FeedsListViewModel()
    private var disposeBag = DisposeBag()
    
    var screenType: ScreenTypes
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = Dimensions.Container.padding4
        return stackView
    }()
    
    init(screenType: ScreenTypes) {
        self.screenType = screenType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFeedsList(screenType: screenType)
    }
    
    private func setupView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.separatorStyle = .singleLine
        tableView.register(FeedCell.self, forCellReuseIdentifier: Strings.Indentifiers.feedCell)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.Localization.addUrl, style: .done, target: self, action: #selector(addURL))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.Localization.addApi, style: .done, target: self, action: #selector(addApiKey))
    }
    
    func bindTableView() {
        
        viewModel.feedResponse.bind(to: tableView.rx.items(cellIdentifier: Strings.Indentifiers.feedCell, cellType: FeedCell.self)) { row, items, cell in
            cell.configureView(with: items)
            
            cell.favorizeButton.rx
                .tap
                .subscribe({ [weak self] _ in
                    guard let self = self else { return }
                    self.viewModel.toggleFeedFavorite(id: items.id, screenType: self.screenType)
                }).disposed(by: cell.bag)
        }.disposed(by: disposeBag)

        tableView.rx
            .modelSelected(FeedObject.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.navigationController?.pushViewController(FeedItemsListViewController(feedName: item.feedName, feedUrl: item.feedUrl), animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx
            .itemDeleted
            .subscribe(onNext: {  [weak self] indexPath in
                guard let self = self else { return }
                do {
                    let currentTableViewData = try self.viewModel.feedResponse.value()
                    self.viewModel.removeFeed(url: currentTableViewData[indexPath.row].feedUrl, screenType: self.screenType)
                } catch {
                    print("Instance fail!")
                }
            }).disposed(by: disposeBag)
    }
    
    func setDelegateForTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    @objc func addURL() {
        let alert = UIAlertController(title: Strings.Localization.addFeed, message: Strings.Localization.enteUrl, preferredStyle: .alert)
        
        alert.addTextField()
        alert.addAction(UIAlertAction(title: Strings.Localization.ok, style: .default, handler: { [weak alert, weak self] (_) in
            guard let self = self else { return }
            
            viewModel.validationResponse.subscribe(onNext: { [weak self] item in
                if !item {
                    self?.wrongEntryAlert()
                }
            }).disposed(by: disposeBag)
            
            if let text = alert?.textFields?[0].text, text != Strings.Localization.empty {
                viewModel.validateAndCreateFeed(url: text, screenType: screenType)
            } else {
                wrongEntryAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addApiKey() {
        
        let alert = UIAlertController(title: Strings.Localization.addApi, message: Strings.Localization.enterApi, preferredStyle: .alert)
        
        alert.addTextField()
        alert.addAction(UIAlertAction(title: Strings.Localization.ok, style: .default, handler: { [weak alert, weak self]  (_) in
            if let text = alert?.textFields?[0].text, text != Strings.Localization.empty {
                let keychain = KeychainSwift()
                keychain.set(text, forKey: Strings.Key.apiKey)
            } else {
                self?.wrongEntryAlert()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func wrongEntryAlert() {
        let secondaryAlert = UIAlertController(title: Strings.Localization.invalidUrl, message: Strings.Localization.empty, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.Localization.ok, style: .cancel)
        secondaryAlert.addAction(okAction)
        self.present(secondaryAlert, animated: true)
    }
}

