import UIKit

fileprivate var loadingView: UIView?

fileprivate var titleLabel: UILabel = .init()

fileprivate var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)


extension UIViewController {
    
    func startLoading() {
        loadingView = UIView(frame: self.view.bounds)
        
        titleLabel.font = Style.Text.title
        titleLabel.text = Strings.Localization.loaderMessage
        
        loadingView?.addSubview(spinner)
        loadingView?.addSubview(titleLabel)

        spinner.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(spinner.snp.bottom).offset(Dimensions.Container.padding8)
            make.centerX.equalToSuperview()
        }
        
        spinner.startAnimating()
        
        if let loadingView  {
            self.view.addSubview(loadingView)
        }
    }
    
    func stopLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
