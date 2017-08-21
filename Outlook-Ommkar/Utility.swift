
import Foundation
import UIKit

extension UIColor {
    static func colorWith(red: CGFloat, blue: CGFloat, green: CGFloat, alpha: CGFloat = 1.0)-> UIColor {
        let base: CGFloat = 255.0
        return UIColor(red: red/base, green: green/base, blue: blue/base, alpha: alpha)
    }
    static func grayColor(value: CGFloat, alpha: CGFloat = 1.0)-> UIColor {
        let grayValue: CGFloat = value/255.0
        return UIColor(red: grayValue, green: grayValue, blue: grayValue, alpha: alpha)
    }
}
