
import Foundation
import UIKit

/*
 Status needs to have enum of status and associated value
 An object with status needs to be able to tell its own status.
 An object displaying the status should get status and display value associated with the status.
 */

protocol Viewable: AnyObject {
    var translatesAutoresizingMaskIntoConstraints: Bool { get set }
    var clipsToBounds: Bool { get set }
    var layer: CALayer { get }
    func layoutIfNeeded()
    init(frame: CGRect)
}
//
protocol RoundViewable: Viewable {}

extension RoundViewable {
    init(diameter: CGFloat) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: diameter)
        let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: diameter)
        NSLayoutConstraint.activate([width, height])
        clipsToBounds = true
        layer.cornerRadius = diameter / 2.0
    }
}

class RoundView: UIView, RoundViewable {
    override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RoundImageView: UIImageView, RoundViewable {
    override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContactLabel: UILabel, ContactDisplayable, RoundViewable {
    override required init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textAlignment = .center
        textColor = .white
        font = UIFont.systemFont(ofSize: 18)
        backgroundColor = UIColor.orange
    }
    
    private func getInitials(string: String)-> String {
        let initials = string.components(separatedBy: .whitespaces).flatMap({ $0.characters.first }).flatMap({ "\($0)".capitalized }).reduce("", +)
        return initials.characters.count > 2 ? initials.substring(to: initials.index(initials.startIndex, offsetBy: 2)) : initials
    }
    
    func displayContact(contact: ContactInformation) {
        if let name = contact.name {
            text = getInitials(string: name)
        }
        else if let email = contact.email {
            text = getInitials(string: email)
        }
    }
}

class RoundLabel: UILabel, RoundViewable {
    override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContactImageView: UIImageView, ContactDisplayable, RoundViewable {
    override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func displayContact(contact: ContactInformation) {
        image = contact.image
    }
}

class EventStatusView: UIView, RoundViewable, ColorDisplayable {
    override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayColor(color: UIColor) {
        backgroundColor = color
    }
}

