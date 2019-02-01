import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
