//
//  RoomCreateTimeAlertController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

fileprivate extension FcrAppUIDateType {
    func component() -> Int {
        switch self {
        case .day:    return 0
        case .hour:   return 1
        case .minute: return 2
        default:      fatalError()
        }
    }
    
    static func create(with component: Int) -> FcrAppUIDateType {
        switch component {
        case 0:  return .day
        case 1:  return .hour
        case 2:  return .minute
        default: fatalError()
        }
    }
    
    func width() -> CGFloat {
        switch self {
        case .day:    return 140
        case .hour:   return 60
        case .minute: return 60
        default:      fatalError()
        }
    }
}

class FcrAppUICreateRoomTimePickerController: FcrAppStartUIPresentedViewController {
    // View
    private let pickerView = UIPickerView(frame: .zero)
    
    // Data
    private let dateTypeList: [FcrAppUIDateType] = [.day,
                                                    .hour,
                                                    .minute]
    private var days = [Date]()
    
    private var hours = [Int]()
    
    private var minutes = [Int]()
    
    private(set) var selectedStartDate: Date {
        didSet {
            printDebug("selectedStartDate: \(selectedStartDate.desc())")
        }
    }
    
    private(set) var selectedDate: Date?
    
    init(date: Date,
         onDismissed: FcrAppCompletion? = nil) {
        self.selectedStartDate = date
        
        super.init(contentHeight: 363,
                   onDismissed: onDismissed)
        
        self.selectedStartDate = modifyDate(date)
        printDebug("init: \(selectedStartDate.desc())")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetDataSource(date: selectedStartDate)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    override func initViews() {
        super.initViews()
        
        contentView.addSubview(pickerView)
        
        bottomButton.addTarget(self,
                               action: #selector(onConfirmButtonPressed(_:)),
                               for: .touchUpInside)
        

        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.reloadAllComponents()
    }
    
    override func initViewFrame() {
        super.initViewFrame()
            
        pickerView.mas_makeConstraints { make in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(0)
            make?.left.equalTo()(20)
            make?.right.equalTo()(-20)
            make?.bottom.equalTo()(bottomButton.mas_top)?.offset()
        }
    }
    
    override func updateViewProperties() {
        super.updateViewProperties()
        titleLabel.text = "fcr_create_select_start_time".localized()
        
        bottomButton.setTitle("fcr_home_button_create".localized(),
                              for: .normal)
    }
    
    @objc private func onConfirmButtonPressed(_ sender: UIButton) {
        var date = getDateFromPicker()
        
        if !valid(date: date) {
            date = Date()
        }
        
        selectedDate = date
        
        dismissSelf()
    }
}

private extension FcrAppUICreateRoomTimePickerController {
    func modifyDate(_ date: Date) -> Date {
        var modified = date
        
        if let multip = minuteIsMultipleOfFive(minute: modified.minute) {
            if multip == 60 {
                modified.hour += 1
                modified.minute = 0
            } else {
                modified.minute = multip
            }
        }
        
        return modified
    }
    
    func resetDataSource(date: Date) {
        days = createDayList(date: date)
        hours = createHourList(startHour: date.hour)
        minutes = createMinuteList(startMinute: date.minute)
    }
    
    func createDayList(date: Date) -> [Date] {
        var futureLimitDayCount = 7
        
        var list = [Date]()
        
        var day = date
        
        while futureLimitDayCount >= 0 {
            list.append(day)
            
            day = day.tomorrow
            
            futureLimitDayCount -= 1
        }
        
        return list
    }
    
    func createHourList(startHour: Int) -> [Int] {
        var hourList = [Int]()
        
        var hour = startHour
        
        while hour < 24 {
            hourList.append(hour)
            
            hour += 1
        }
        
        return hourList
    }
    
    func createMinuteList(startMinute: Int) -> [Int] {
        var minuteList = [Int]()
        
        var minute = startMinute
        
        if let multip = minuteIsMultipleOfFive(minute: minute) {
            minute = multip
        }
        
        while minute < 60 {
            minuteList.append(minute)
            minute += 5
        }
        
        return minuteList
    }
    
    func minuteIsMultipleOfFive(minute: Int) -> Int? {
        guard minute % 5 != 0 else {
            return nil
        }
        
        let multip = Int(ceil((Float(minute) / 5))) * 5
        
        if (multip % 5 != 0) {
            printDebug("minuteIsMultipleOfFive minute: \(minute)")
            printDebug("minuteIsMultipleOfFive multip: \(multip)")
            fatalError()
        }
        
        if multip < 60 {
            return multip
        } else {
            return nil
        }
    }
   
    func getDateFromPicker() -> Date {
        var date = days[pickerView.selectedRow(inComponent: FcrAppUIDateType.day.component())]
        date.hour = hours[pickerView.selectedRow(inComponent: FcrAppUIDateType.hour.component())]
        date.minute = minutes[pickerView.selectedRow(inComponent: FcrAppUIDateType.minute.component())]
        
        printDebug("getDateFromPicker: \(date.desc())")
        
        return date
    }
}

// MARK: - UIPickerViewDataSource
extension FcrAppUICreateRoomTimePickerController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        let type = FcrAppUIDateType.create(with: component)
        
        switch type {
        case .day:
            return days.count
        case .hour:
            return hours.count
        case .minute:
            return minutes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    widthForComponent component: Int) -> CGFloat {
        let type = FcrAppUIDateType.create(with: component)
        return type.width()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dateTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let type = FcrAppUIDateType.create(with: component)
        
        let text = pickerViewTitle(forRow: row,
                                   forType: type)
        
        if let label = view as? UILabel {
            label.text = text
            return label
        } else {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .black
            label.textAlignment = .center
            label.text = text
            return label
        }
    }
    
    func pickerViewTitle(forRow row: Int,
                         forType type: FcrAppUIDateType) -> String? {
        switch type {
        case .day:
            if row == 0 {
                return "fcr_create_picker_today".localized()
            } else {
                let date = days[row]
                return date.string(withFormat: "fcr_create_picker_time_format".localized())
            }
        case .hour:
            let hour = hours[row]
            return String(format: "%02d", hour)
        case .minute:
            let minute = minutes[row]
            return String(format: "%02ld", minute)
        default:
            return nil
        }
    }
}

// MARK: - UIPickerViewDelegate
extension FcrAppUICreateRoomTimePickerController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        let type = FcrAppUIDateType.create(with: component)
        
        let date = getDateFromPicker()
        
        guard valid(date: date) else {
            return
        }
        
        let last = selectedStartDate
        printDebug("last: \(last.desc())")
        selectedStartDate = date
        
        updateDataSource(date: date)
        
        switch type {
        case .day:
            pickerView.reloadComponent(FcrAppUIDateType.hour.component())
            pickerView.reloadComponent(FcrAppUIDateType.minute.component())
            
            selectPickerRow(type: .hour,
                            value: last.hour)
            
            selectPickerRow(type: .minute,
                            value: last.minute)
        case .hour:
            pickerView.reloadComponent(FcrAppUIDateType.minute.component())
            
            selectPickerRow(type: .minute,
                            value: last.minute)
        default:
            break
        }
    }
    
    func valid(date: Date) -> Bool {
        let current = Date()
        
        if date >= current {
            return true
        } else {
            resetDataSource(date: current)
            pickerView.reloadAllComponents()
            
            pickerScroll(to: 0,
                         type: .hour)
            
            pickerScroll(to: 0,
                         type: .minute)
            
            printDebug("invalid")
            selectedStartDate = current
            return false
        }
    }
    
    func updateDataSource(date: Date) {
        if date.isInToday {
            let current = Date()
            
            hours = createHourList(startHour: current.hour)
            
            if current.hour == date.hour {
                minutes = createMinuteList(startMinute: current.minute)
            } else {
                minutes = createMinuteList(startMinute: 0)
            }
        } else {
            hours = createHourList(startHour: 0)
            minutes = createMinuteList(startMinute: 0)
        }
    }
    
    func selectPickerRow(type: FcrAppUIDateType,
                         value: Int) {
        switch type {
        case .hour:
            if let selected = hours.firstIndex(where: {$0 == value}) {
                print(">>>>>>>>>> hours firstIndex: \(selected), value: \(value)")
                
                pickerScroll(to: selected,
                             type: type)
            }
        case .minute:
            if let selected = minutes.firstIndex(where: {$0 == value}) {
                print(">>>>>>>>>> minutes firstIndex: \(selected), value: \(value)")
                
                pickerScroll(to: selected,
                             type: type)
            }
        default:
            fatalError()
        }
    }
    
    func pickerScroll(to row: Int,
                      type: FcrAppUIDateType,
                      animated: Bool = false) {
        DispatchQueue.main.async {
            self.pickerView.selectRow(row,
                                      inComponent: type.component(),
                                      animated: animated)
        }
    }
}

fileprivate extension Date {
    func desc() -> String {
        return "Day: \(day), Hour: \(hour), Minute: \(minute)"
    }
}
