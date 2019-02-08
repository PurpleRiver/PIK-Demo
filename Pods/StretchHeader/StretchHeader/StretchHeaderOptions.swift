
import UIKit

open class StretchHeaderOptions {
    
    open var position : HeaderPosition = .fullScreenTop
    
    public enum HeaderPosition {
        case fullScreenTop
        case underNavigationBar
    }
    
    public init() {}
}
