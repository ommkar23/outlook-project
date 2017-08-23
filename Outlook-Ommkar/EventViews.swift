
import Foundation
import UIKit

class ContactImageCollectionViewCell: UICollectionViewCell, ContactDisplayable {
    let contactImageView = ContactImageView(diameter: 35)
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addComponents()
        addLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        contentView.addSubview(contactImageView)
    }
    
    private func addLayoutConstraints() {
        contactImageView.translatesAutoresizingMaskIntoConstraints = false
        let contactCenterX = NSLayoutConstraint(item: contactImageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let contactCenterY = NSLayoutConstraint(item: contactImageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([contactCenterX, contactCenterY])
    }
    
    func displayContact(contact: ContactInformation) {
        contactImageView.displayContact(contact: contact)
    }
}

class ContactLabelCollectionViewCell: UICollectionViewCell, ContactLabelDisplayable {
    let contactLabel = ContactLabel(diameter: 35)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        addLayoutConstraints()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        contentView.addSubview(contactLabel)
    }
    
    private func addLayoutConstraints() {
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        let contactCenterX = NSLayoutConstraint(item: contactLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let contactCenterY = NSLayoutConstraint(item: contactLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([contactCenterX, contactCenterY])
    }
    
    func displayContact(contact: ContactInformation) {
        contactLabel.displayContact(contact: contact)
    }
    
    func setColor(_ color: UIColor) {
        contactLabel.backgroundColor = color
    }
}

class AttendeeCollectionView: UICollectionView, HorizontalContactDisplay {
    let cellSize = CGSize(width: 35, height: 35)
    var contactList: [ContactInformation] = []
    let moreContactReuseIdentifier = "MoreContactCellReuseIdentifier"
    let imageContactReuseIdentifier = "ImageContactCellReuseIdentifier"
    let labelContactReuseIdentifier = "LabelContactCellReuseIdentifier"
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: cellSize.height)
        NSLayoutConstraint.activate([heightConstraint])
        register(ContactImageCollectionViewCell.self, forCellWithReuseIdentifier: imageContactReuseIdentifier)
        register(ContactLabelCollectionViewCell.self, forCellWithReuseIdentifier: labelContactReuseIdentifier)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func displayContactList(contactList: [ContactInformation]) {
        self.contactList = contactList
        reloadData()
    }
    func getColor(for index: Int)-> UIColor {
        let rgbValues: [(CGFloat, CGFloat, CGFloat)] = [(27, 161, 226), (0, 138, 0), (216, 0, 115), (170, 0, 255)]
        let rgbValue = rgbValues[index % rgbValues.count]
        return UIColor.colorWith(red: rgbValue.0, blue: rgbValue.1, green: rgbValue.2)
    }
}

extension AttendeeCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contact = contactList[indexPath.row]
        let reuseIdentifier = contact.image != nil ? imageContactReuseIdentifier : labelContactReuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? ContactDisplayable {
            cell.displayContact(contact: contact)
        }
        if let cell = cell as? ContactLabelDisplayable {
            cell.setColor(getColor(for: indexPath.row))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

class EventLocationView: UIView {
    let iconView = UIImageView()
    let descriptionLabel = UILabel()
    let iconImage = UIImage(named: "ic_location")
    let iconSide: CGFloat = 10
    init() {
        super.init(frame: .zero)
        addComponents()
        addLayoutConstraints()
        configureComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        addSubview(iconView)
        addSubview(descriptionLabel)
    }
    
    private func addLayoutConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let iconLeading = NSLayoutConstraint(item: iconView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        let iconCenterY = NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: descriptionLabel, attribute: .centerY, multiplier: 1.0, constant: 0)
        let iconWidth = NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: iconSide)
        let iconHeight = NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: iconSide)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        let descLeading = NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: iconView, attribute: .trailing, multiplier: 1.0, constant: 4)
        let descTrailing = NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let descTop = NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let descBottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: descriptionLabel, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([iconLeading, iconCenterY, iconWidth, iconHeight,
                                     descLeading, descTop, descBottom, descTrailing])
    }
    
    private func configureComponents() {
        iconView.contentMode = .scaleAspectFit
        iconView.image = iconImage
        descriptionLabel.font = UIFont.systemFont(ofSize: 14.0)
        descriptionLabel.textColor = UIColor.grayColor(value: 100)
        descriptionLabel.numberOfLines = 1
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.textAlignment = .left
    }
}

extension EventLocationView: EventLocationDisplay {
    func displayEventLocation(location: LocationInformation) {
        descriptionLabel.text = location.description
    }
}

class EventTimeDescriptionView: UIView {
    let durationLabel = UILabel()
    let startTimeLabel = UILabel()
    let statusView = EventStatusView(diameter: 10)
    init() {
        super.init(frame: .zero)
        addComponents()
        addLayoutConstraints()
        configureComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        addSubview(durationLabel)
        addSubview(startTimeLabel)
        addSubview(statusView)
    }
    
    func addLayoutConstraints() {
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        let startTop = NSLayoutConstraint(item: startTimeLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let startLeading = NSLayoutConstraint(item: startTimeLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        let durationTop = NSLayoutConstraint(item: durationLabel, attribute: .top, relatedBy: .equal, toItem: startTimeLabel, attribute: .bottom, multiplier: 1.0, constant: 2.0)
        let durationLeading = NSLayoutConstraint(item: durationLabel, attribute: .leading, relatedBy: .equal, toItem: startTimeLabel, attribute: .leading, multiplier: 1.0, constant: 0)
        
        statusView.translatesAutoresizingMaskIntoConstraints = false
        let statusCenterY = NSLayoutConstraint(item: statusView, attribute: .centerY, relatedBy: .equal, toItem: startTimeLabel, attribute: .centerY, multiplier: 1.0, constant: 0)
        let statusTrailing = NSLayoutConstraint(item: statusView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        let viewBottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: durationLabel, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([startTop, startLeading,
                                     durationTop, durationLeading, viewBottom,
                                     statusCenterY, statusTrailing])
    }
    
    func configureComponents() {
        startTimeLabel.textAlignment = .left
        startTimeLabel.font = UIFont.systemFont(ofSize: 14)
        startTimeLabel.textColor = .black
        startTimeLabel.numberOfLines = 1
        
        durationLabel.textAlignment = .left
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.textColor = UIColor.grayColor(value: 150)
        durationLabel.numberOfLines = 1
    }
}

extension EventTimeDescriptionView: EventTimeDescriptionDisplay {
    var durationText: String? {
        get {
            return durationLabel.text
        }
        set {
            durationLabel.text = newValue
        }
    }
    var startTimeText: String? {
        get {
            return startTimeLabel.text
        }
        set {
            startTimeLabel.text = newValue
        }
    }
    var statusColor: UIColor? {
        get {
            return statusView.backgroundColor
        }
        set {
            statusView.backgroundColor = newValue
        }
    }
}

class EventBasicInfoCell: UITableViewCell, EventInformationDisplay {
    let timeDescriptionView = EventTimeDescriptionView()
    let titleLabel = UILabel()
    var layoutConstraints: [NSLayoutConstraint] = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        addLayoutConstraints()
        configureComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        contentView.addSubview(timeDescriptionView)
        contentView.addSubview(titleLabel)
    }
    
    private func addLayoutConstraints() {
        timeDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        let timeDescLeading = NSLayoutConstraint(item: timeDescriptionView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 12.0)
        let timeDescTop = NSLayoutConstraint(item: timeDescriptionView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 12.0)
        let timeDescWidth = NSLayoutConstraint(item: timeDescriptionView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 88.0)
        let timeDescBottom = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: timeDescriptionView, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: timeDescriptionView, attribute: .trailing, multiplier: 1.0, constant: 12.0)
        let titleTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: timeDescriptionView, attribute: .top, multiplier: 1.0, constant: 0)
        let titleTrailing = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -12.0)
        titleTrailing.priority = UILayoutPriorityDefaultHigh
        let titleBottom = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        
        layoutConstraints = [timeDescLeading, timeDescTop, timeDescBottom, timeDescWidth,
                                     titleLeading, titleTop, titleTrailing, titleBottom]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func configureComponents() {
        selectionStyle = .none
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 16.0)
        titleLabel.textColor = UIColor.darkText
        titleLabel.lineBreakMode = .byTruncatingTail
    }
    
    func displayEventInformation(eventInfo: EventInformation) {
        timeDescriptionView.durationText = eventInfo.durationString
        timeDescriptionView.startTimeText = eventInfo.startTimeString
        timeDescriptionView.statusColor = eventInfo.status.color
        titleLabel.text = eventInfo.title
        
    }
}

class EventAttendeeInfoCell: EventBasicInfoCell {
    let attendeesDisplay = AttendeeCollectionView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        addLayoutConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addComponents() {
        contentView.addSubview(attendeesDisplay)
    }
    private func addLayoutConstraints() {
        attendeesDisplay.translatesAutoresizingMaskIntoConstraints = false
        let leading = NSLayoutConstraint(item: attendeesDisplay, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: 0)
        let top = NSLayoutConstraint(item: attendeesDisplay, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 8)
        let trailing = NSLayoutConstraint(item: attendeesDisplay, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: attendeesDisplay, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -8.0)
        
        NSLayoutConstraint.activate([leading, top, trailing, bottom])
    }
    override func displayEventInformation(eventInfo: EventInformation) {
        super.displayEventInformation(eventInfo: eventInfo)
        if let attendeeList = eventInfo.attendeesList {
            attendeesDisplay.displayContactList(contactList: attendeeList)
        }
    }
}

class EventLocationInfoCell: EventBasicInfoCell {
    let locationView = EventLocationView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        addLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        contentView.addSubview(locationView)
    }
    
    private func addLayoutConstraints() {
        locationView.translatesAutoresizingMaskIntoConstraints = false
        let locationLeading = NSLayoutConstraint(item: locationView, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: 0)
        let locationTop = NSLayoutConstraint(item: locationView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        let locationTrailing = NSLayoutConstraint(item: locationView, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1.0, constant: 0)
        let locationBottom = NSLayoutConstraint(item: locationView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -8.0)
        
        NSLayoutConstraint.activate([locationLeading, locationTop, locationTrailing, locationBottom])
    }
    
    override func displayEventInformation(eventInfo: EventInformation) {
        super.displayEventInformation(eventInfo: eventInfo)
        if let locationInfo = eventInfo.locationInfo {
            locationView.displayEventLocation(location: locationInfo)
        }
    }
}

class EventLocationWeatherInfoCell: EventLocationInfoCell {
    let weatherIcon = UIImageView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        addLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addComponents() {
        contentView.addSubview(weatherIcon)
    }
    
    private func addLayoutConstraints() {
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        let leading = NSLayoutConstraint(item: weatherIcon, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 22)
        let top = NSLayoutConstraint(item: weatherIcon, attribute: .top, relatedBy: .equal, toItem: timeDescriptionView, attribute: .bottom, multiplier: 1.0, constant: 12.0)
        let width = NSLayoutConstraint(item: weatherIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        let height = NSLayoutConstraint(item: weatherIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        let bottom = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: weatherIcon, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        NSLayoutConstraint.activate([leading, top, width, height, bottom])
    }
    
    override func displayEventInformation(eventInfo: EventInformation) {
        super.displayEventInformation(eventInfo: eventInfo)
        if let weatherIconString = eventInfo.weatherIcon {
            weatherIcon.image = UIImage(named: "ic_\(weatherIconString)")
        }
    }
}

class EventCompleteInfoCell: EventAttendeeInfoCell {
    let locationView = EventLocationView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        addLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        contentView.addSubview(locationView)
    }
    
    private func addLayoutConstraints() {
        locationView.translatesAutoresizingMaskIntoConstraints = false
        let locationLeading = NSLayoutConstraint(item: locationView, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: 0)
        let locationTop = NSLayoutConstraint(item: locationView, attribute: .top, relatedBy: .equal, toItem: attendeesDisplay, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        let locationTrailing = NSLayoutConstraint(item: locationView, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1.0, constant: 0)
        let locationBottom = NSLayoutConstraint(item: locationView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -8.0)
        
        NSLayoutConstraint.activate([locationLeading, locationTop, locationTrailing, locationBottom])
    }
    
    override func displayEventInformation(eventInfo: EventInformation) {
        super.displayEventInformation(eventInfo: eventInfo)
        if let locationInfo = eventInfo.locationInfo {
            locationView.displayEventLocation(location: locationInfo)
        }
    }
}

class EventCompleteWeatherInfoCell: EventCompleteInfoCell {
    let weatherIcon = UIImageView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        addLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addComponents() {
        contentView.addSubview(weatherIcon)
    }
    
    private func addLayoutConstraints() {
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        let leading = NSLayoutConstraint(item: weatherIcon, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 22)
        let top = NSLayoutConstraint(item: weatherIcon, attribute: .top, relatedBy: .equal, toItem: timeDescriptionView, attribute: .bottom, multiplier: 1.0, constant: 12.0)
        let width = NSLayoutConstraint(item: weatherIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        let height = NSLayoutConstraint(item: weatherIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        let bottom = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: weatherIcon, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        NSLayoutConstraint.activate([leading, top, width, height, bottom])
    }
    
    override func displayEventInformation(eventInfo: EventInformation) {
        super.displayEventInformation(eventInfo: eventInfo)
        if let weatherIconString = eventInfo.weatherIcon {
            weatherIcon.image = UIImage(named: "ic_\(weatherIconString)")
        }
    }
}
