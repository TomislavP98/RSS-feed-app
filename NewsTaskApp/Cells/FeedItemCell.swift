import UIKit
import SnapKit

final class FeedItemCell: UITableViewCell {
    
    static let identifier = Strings.Indentifiers.feedItemCell
    
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = Dimensions.Container.padding8
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
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Style.Text.date
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = Style.Text.description
        return label
    }()
    
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    private func setupView() {
        contentView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(itemImageView)
        contentStack.addArrangedSubview(labelStack)
        
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(dateLabel)
        labelStack.addArrangedSubview(descriptionLabel)
        
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimensions.Container.itemInset)
        }
        
        itemImageView.snp.makeConstraints { make in
            make.size.equalTo(Dimensions.Pictures.normal)
        }
    }
    
    func configureView(with data: FeedItem) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description ?? Strings.Localization.noDescription
        dateLabel.text = formatDate(date: data.time ?? "")
        
        if let imageURL = URL(string: data.image?.url ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.itemImageView.image = image
                        }
                    }
                }
            }
        }
        
    }
    
    private func formatDate(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        let displayDateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: Date.Posix.en_us)
        dateFormatter.dateFormat = Date.DateFormats.sourceFormat
        displayDateFormatter.dateFormat = Date.DateFormats.appFormat
        
        if let formattedDate = dateFormatter.date(from: date) {
            dateFormatter.timeZone = TimeZone.current
            return displayDateFormatter.string(from: formattedDate)
        } else {
            return Strings.Localization.empty
        }
    }
}
