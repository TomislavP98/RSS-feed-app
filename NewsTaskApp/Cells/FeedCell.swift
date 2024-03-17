import RxSwift
import RxCocoa
import UIKit
import SnapKit

class FeedCell: UITableViewCell {
    
    static let identifier = Strings.Indentifiers.feedCell
    var bag: DisposeBag = DisposeBag()

    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var labelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Dimensions.Container.padding4
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.Text.title
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Style.Text.description
        return label
    }()
    
    lazy var favorizeButton: UIButton = {
        let button = UIButton()
        button.layer.zPosition = 3
        return button
    }()
         
    lazy var favoriteImageView: UIImageView = .init(image: UIImage(systemName: "heart"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    private func setupView() {
        contentView.addSubview(contentStack)
        contentStack.addArrangedSubview(favorizeButton)
        contentStack.addArrangedSubview(labelStack)
        
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(descriptionLabel)
    
        favorizeButton.addSubview(favoriteImageView)
        
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimensions.Container.feedInset)
        }
        
        
        favorizeButton.snp.makeConstraints { make in
            make.size.equalTo(Dimensions.Icons.normal)
            make.right.equalTo(labelStack.snp.left).offset(-Dimensions.Container.padding16)
        }
        
        favoriteImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
    }
    
    func configureView(with data: FeedObject) {
        titleLabel.text = data.feedName
        descriptionLabel.text = data.feedUrl
        favoriteImageView.image = data.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    
}
