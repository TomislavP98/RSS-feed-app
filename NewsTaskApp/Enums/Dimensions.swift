import CoreGraphics
import UIKit

enum Dimensions {
    enum Icons {
        static let normal: CGSize = .init(width: 25, height: 25)
    }
    
    enum Pictures {
        static let normal: CGSize = .init(width: 80, height: 65)
    }
    
    enum Container {
        static let padding16: CGFloat = 16
        static let padding8: CGFloat = 8
        static let padding4: CGFloat = 4
        static let feedInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let itemInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
    }
    
    enum TextSize {
        static let title: CGFloat = 8
        static let description: CGFloat = 8
        static let date: CGFloat = 8
    }
}
