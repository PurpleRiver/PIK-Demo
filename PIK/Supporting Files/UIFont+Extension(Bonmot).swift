import Foundation
import BonMot

extension UIFont {
    
    static func appFont(ofSize pointSize: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: pointSize)!
    }
    
    static func appFontBold(ofSize pointSize: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica-Bold", size: pointSize)!
    }
}
