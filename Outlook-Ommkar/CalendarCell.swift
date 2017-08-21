
import Foundation
import UIKit

class CalendarCell: UICollectionViewCell, CalendarDayDisplayable {
    func displayCalendarDay(calendarDay: CalendarDayInformation) {
        let currentMonth = Calendar.current.component(.month, from: Date())
        contentView.backgroundColor = (currentMonth % 2) ^ (calendarDay.month % 2) != 0 ? UIColor.grayColor(value: 245) : .white
    }
}

class CalendarDateCell: CalendarCell {
    let dateLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        addLayoutConstraints()
        configureComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        contentView.addSubview(dateLabel)
    }
    
    private func addLayoutConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let labelCenterX = NSLayoutConstraint(item: dateLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let labelCenterY = NSLayoutConstraint(item: dateLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([labelCenterX, labelCenterY])
    }
    private func configureComponents() {
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.textColor = UIColor.darkGray
        dateLabel.textAlignment = .center
    }
    
    override func displayCalendarDay(calendarDay: CalendarDayInformation) {
        super.displayCalendarDay(calendarDay: calendarDay)
        dateLabel.text = "\(calendarDay.day)"
    }
}

class CalendarSelectedDateCell: CalendarCell {
    let dateLabel = RoundLabel(diameter: 35.0)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        addLayoutConstraints()
        configureComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addComponents() {
        contentView.addSubview(dateLabel)
    }
    
    private func addLayoutConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let labelCenterX = NSLayoutConstraint(item: dateLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let labelCenterY = NSLayoutConstraint(item: dateLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([labelCenterX, labelCenterY])
    }
    private func configureComponents() {
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = .blue
    }
    
    override func displayCalendarDay(calendarDay: CalendarDayInformation) {
        super.displayCalendarDay(calendarDay: calendarDay)
        dateLabel.text = "\(calendarDay.day)"
    }
}

class CalendarEventDateCell: CalendarDateCell {
    let hasEventView = RoundView(diameter: 6)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        addLayoutConstraints()
        configureComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addComponents() {
        contentView.addSubview(hasEventView)
    }
    private func addLayoutConstraints() {
        hasEventView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: hasEventView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let centerY = NSLayoutConstraint(item: hasEventView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -10.0)
        NSLayoutConstraint.activate([centerX, centerY])
    }
    private func configureComponents() {
        hasEventView.backgroundColor = .lightGray
    }
}

class CalendarMonthDateCell: CalendarCell {
    let monthLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        addLayoutConstraints()
        configureComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(monthLabel)
    }
    private func addLayoutConstraints() {
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        let monthCenterX = NSLayoutConstraint(item: monthLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let monthTop = NSLayoutConstraint(item: monthLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 2.0)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let dateCenterX = NSLayoutConstraint(item: dateLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let dateBottom = NSLayoutConstraint(item: dateLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -3.0)
        
        NSLayoutConstraint.activate([monthCenterX, monthTop, dateCenterX, dateBottom])
    }
    
    private func configureComponents() {
        monthLabel.font = UIFont.systemFont(ofSize: 12.0)
        monthLabel.textColor = UIColor.grayColor(value: 120.0)
        monthLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.textColor = UIColor.darkGray
        dateLabel.textAlignment = .center
    }
    
    override func displayCalendarDay(calendarDay: CalendarDayInformation) {
        super.displayCalendarDay(calendarDay: calendarDay)
        dateLabel.text = "\(calendarDay.day)"
        monthLabel.text = calendarDay.shortMonthString
    }
}

class DayLabel: UILabel {
    init(day: Int) {
        super.init(frame: .zero)
        text = ["S", "M", "T", "W", "T", "F", "S"][day-1]
        font = UIFont.systemFont(ofSize: 14.0)
        textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CalendarDayHeaderView: UIStackView {
    init() {
        super.init(frame: .zero)
        (1...7).forEach {  addArrangedSubview(DayLabel(day: $0)) }
        alignment = .center
        axis = .horizontal
        distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
