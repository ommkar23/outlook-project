
import UIKit

protocol DequeDelegate: AnyObject {
    func didUpdateMinimum(newValue: Int, oldValue: Int, withReset: Bool)
}

struct Deque {
/*
     Deque will maintain the sections being displayed currently by the table view in sorted order, where the first element is minimum section being displayed. This is to make calendar date selection as we scroll the tableview.
 */
    weak var delegate: DequeDelegate?
    private var deque: [Int] = []
    mutating func insert(index: Int) {
        if deque.isEmpty {
            deque.insert(index, at: 0)
        }
        else {
            if let first = deque.first,
                let last = deque.last,
                first <= last {
                if index < first {
                    deque.insert(index, at: 0)
                }
                if index > last {
                    deque.append(index)
                }
            }
        }
        if let first = deque.first {
            minimumIndex = first
        }
    }
    
    mutating func remove(index: Int) {
        if !deque.isEmpty {
            if let first = deque.first,
                let last = deque.last {
                if index == first {
                    _ = deque.removeFirst()
                }
                else if index == last {
                    _ = deque.removeLast()
                }
            }
        }
        if let first = deque.first {
            minimumIndex = first
        }
    }
    
    mutating func reset(withIndex index: Int?) {
        deque = []
        if let index = index {
            deque.insert(index, at: 0)
            hasReset = true
            minimumIndex = index
        }
        
    }
    var hasReset: Bool = false
    var minimumIndex: Int = 0 {
        didSet {
            if minimumIndex != oldValue {
                delegate?.didUpdateMinimum(newValue: minimumIndex, oldValue: oldValue, withReset: hasReset)
                hasReset = false
            }
        }
    }
}

class ViewController: UIViewController {
    let dayHeaderView = CalendarDayHeaderView()
    let tableView = UITableView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    // Tableview cell reuse identifiers
    let noEventCellIdentifier = "NoEventCellReuseIdentifier"
    let basicEventCellIdentifier = "BasicEventInfoCellReuseIDentifier"
    let locationEventCellIdentifier = "LocationEventInfoCellReuseIdentifier"
    let completeEventCellIdentifier = "CompleteEventInfoCellReuseIdentifier"
    let attendeeEventCellIdentifier = "AttendeeEventInfoCellReuseIdentifier"
    
    //Collectionview cell reuse identifiers
    let calendarCellIdentifier = "CalendarCellReuseIdentifier"
    let selectedCalendarCellIdentifier = "SelectedCalendarCellReuseIdentifier"
    let calendarEventCellIdentifier = "CalendarEventCellReuseIdentifier"
    let calendarMonthCellIdentifier = "CalendarMonthCellReuseIdentifier"
    
    //Collectionview constants
    let interItemSpacing: CGFloat = 0
    let interLineSpacing: CGFloat = 0.5
    let numberOfItemsPerRow = 7
    var itemSize: CGSize {
        let side: CGFloat = UIScreen.main.bounds.size.width / CGFloat(numberOfItemsPerRow)
        return CGSize(width: side, height: side)
    }
    
    var calendarExpanded = false
    var scrollingByEffect = false
    
    var deque = Deque()
    
    var cvHeight: CGFloat {
        return calendarExpanded ? CGFloat(4) * (itemSize.height + interLineSpacing) : CGFloat(2) * (itemSize.height + interLineSpacing)
    }
    
    //Contraint used to toggle calendar expansion
    var cvHeightConstraint: NSLayoutConstraint!
    
    var calendarModel = CalendarModel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addComponents()
        addLayoutConstraints()
        configureComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        view.addSubview(dayHeaderView)
        view.addSubview(collectionView)
        view.addSubview(tableView)
    }
    
    func addLayoutConstraints() {
        dayHeaderView.translatesAutoresizingMaskIntoConstraints = false
        let dayTop = NSLayoutConstraint(item: dayHeaderView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        let dayLeading = NSLayoutConstraint(item: dayHeaderView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        let dayTrailing = NSLayoutConstraint(item: dayHeaderView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
        let dayHeight = NSLayoutConstraint(item: dayHeaderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 35)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let cvTop = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: dayHeaderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let cvLeading = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        let cvTrailing = NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
        cvHeightConstraint = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: cvHeight)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tvTop = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let tvLeading = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        let tvTrailing = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
        let tvBottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([dayTop, dayLeading, dayTrailing, dayHeight,
                                     cvTop, cvLeading, cvTrailing, cvHeightConstraint,
                                     tvTop, tvLeading, tvTrailing, tvBottom])
    }
    
    func configureComponents() {
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: noEventCellIdentifier)
        tableView.register(EventBasicInfoCell.self, forCellReuseIdentifier: basicEventCellIdentifier)
        tableView.register(EventLocationInfoCell.self, forCellReuseIdentifier: locationEventCellIdentifier)
        tableView.register(EventAttendeeInfoCell.self, forCellReuseIdentifier: attendeeEventCellIdentifier)
        tableView.register(EventCompleteInfoCell.self, forCellReuseIdentifier: completeEventCellIdentifier)
        
        collectionView.register(CalendarDateCell.self, forCellWithReuseIdentifier: calendarCellIdentifier)
        collectionView.register(CalendarSelectedDateCell.self, forCellWithReuseIdentifier: selectedCalendarCellIdentifier)
        collectionView.register(CalendarEventDateCell.self, forCellWithReuseIdentifier: calendarEventCellIdentifier)
        collectionView.register(CalendarMonthDateCell.self, forCellWithReuseIdentifier: calendarMonthCellIdentifier)
        
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.bounces = false
        
        tableView.bounces = false
        tableView.rowHeight = UITableViewAutomaticDimension
        
        calendarModel.delegate = self
        deque.delegate = self
        calendarModel.loadEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func toggleCollectionViewExpansion() {
        if scrollingByEffect {
            scrollingByEffect = false
            return
        }
        calendarExpanded = !calendarExpanded
        cvHeightConstraint.constant = cvHeight
        UIView.animate(withDuration: 0.5) {
            [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return calendarModel.dayCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dayInfo = calendarModel.dayInformation(at: section)
        return dayInfo.hasEvent ? dayInfo.eventCount : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dayInfo = calendarModel.dayInformation(at: indexPath.section)
        if dayInfo.hasEvent {
            let eventInfo: EventInformation = dayInfo.eventInformation(at: indexPath.row)
            var cell: UITableViewCell
            switch (eventInfo.attendeesList, eventInfo.locationInfo) {
            case (nil, nil):
                cell = tableView.dequeueReusableCell(withIdentifier: basicEventCellIdentifier, for: indexPath)
                break
            case (nil, _):
                cell = tableView.dequeueReusableCell(withIdentifier: locationEventCellIdentifier, for: indexPath)
                break
            case (_, nil):
                cell = tableView.dequeueReusableCell(withIdentifier: attendeeEventCellIdentifier, for: indexPath)
                break
            case (_, _):
                cell = tableView.dequeueReusableCell(withIdentifier: completeEventCellIdentifier, for: indexPath)
                break
            }
            if let cell = cell as? EventInformationDisplay {
                cell.displayEventInformation(eventInfo: eventInfo)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: noEventCellIdentifier, for: indexPath)
            cell.textLabel?.text = "No event"
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return calendarModel.dayInformation(at: section).displayString
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        deque.insert(index: section)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        deque.remove(index: section)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarModel.dayCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dayInfo = calendarModel.dayInformation(at: indexPath.row)
        let cellOptions = dayInfo.calendarCellOptions
        let reuseIdentifier: String
        if cellOptions.contains(.selected) {
            reuseIdentifier = selectedCalendarCellIdentifier
        }
        else if cellOptions.contains(.firstDay) {
            reuseIdentifier = calendarMonthCellIdentifier
        }
        else if cellOptions.contains(.hasEvent) {
            reuseIdentifier = calendarEventCellIdentifier
        }
        else {
            reuseIdentifier = calendarCellIdentifier
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? CalendarDayDisplayable {
            cell.displayCalendarDay(calendarDay: dayInfo)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deque.reset(withIndex: indexPath.row)
        tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.row), at: .top, animated: false)
        calendarModel.select(at: indexPath.row)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView is UICollectionView {
            if !calendarExpanded {
                scrollingByEffect = false
                toggleCollectionViewExpansion()
            }
        }
        if scrollView is UITableView {
            if calendarExpanded {
                scrollingByEffect = false
                toggleCollectionViewExpansion()
            }
        }
    }
}

extension ViewController: CalendarModelUpdate {
    func didSelect(at index: Int) {
        collectionView.performBatchUpdates ({
            [weak self] in
            self?.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        })
        title = calendarModel.dayInformation(at: index).titleString
    }
    
    func didDeSelect(at index: Int) {
        collectionView.performBatchUpdates ({
            [weak self] in
            self?.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        })
    }
    
    func modelIsReady() {
        deque.reset(withIndex: nil)
        if let todayIndex = calendarModel.selectToday() {
            tableView.scrollToRow(at: IndexPath(row: 0, section: todayIndex), at: .top, animated: false)
            collectionView.scrollToItem(at: IndexPath(row: todayIndex, section: 0), at: .top, animated: false)
        }
    }
}

extension ViewController: DequeDelegate {
    func didUpdateMinimum(newValue: Int, oldValue: Int, withReset: Bool) {
        calendarModel.select(at: newValue)
        if withReset { return }
        scrollingByEffect = true
        var scrollPosition: UICollectionViewScrollPosition
        if newValue < oldValue {
            scrollPosition = .bottom
        }
        else {
            scrollPosition = .top
        }
        let newIndexPath = IndexPath(row: newValue, section: 0)
        collectionView.performBatchUpdates({
            [weak self] in
            self?.collectionView.scrollToItem(at: newIndexPath, at: scrollPosition, animated: true)
        })
    }
}

