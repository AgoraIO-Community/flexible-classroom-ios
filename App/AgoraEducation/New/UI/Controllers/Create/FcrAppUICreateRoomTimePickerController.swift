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

class FcrAppUICreateRoomTimePickerController: FcrAppViewController {
    // View
    private let contentView = UIView()
    
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let backgroundImageView = UIImageView(frame: .zero)
    
    private let titleLabel = UILabel()
    
    private let submitButton = UIButton(type: .custom)
    
    private let cancelButton = UIButton(type: .custom)
    
    private let pickerView = UIPickerView(frame: .zero)
    
    // Data source
    private let dateTypeList: [FcrAppUIDateType] = [.day,
                                                    .hour,
                                                    .minute]
    private var days = [Date]()
    
    private var hours = [Int]()
    
    private var minutes = [Int]()
    
    private var selectedDate = Date() {
        didSet {
            print(">>>>>>>>>> selectedDate: \(selectedDate.day), \(selectedDate.hour), \(selectedDate.minute)")
        }
    }
    
    private var complete: ((Date) -> Void)?
    
    init(date: Date) {
        self.selectedDate = date
        super.init(nibName: nil,
                   bundle: nil)
        
        self.selectedDate = initDate()
        print(">>>>>>>>>> init: \(selectedDate.desc())")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetDataSource(date: selectedDate)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
}

extension FcrAppUICreateRoomTimePickerController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(contentView)
        contentView.addSubview(effectView)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(submitButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(pickerView)
        
        contentView.layer.cornerRadius = 40
        contentView.clipsToBounds = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        submitButton.addTarget(self,
                               action: #selector(onClickSubmmit(_:)),
                               for: .touchUpInside)
        
        submitButton.setTitleColor(.white,
                                   for: .normal)
        submitButton.layer.cornerRadius = 23
        submitButton.clipsToBounds = true
        
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        cancelButton.addTarget(self,
                               action: #selector(onClickCancel(_:)),
                               for: .touchUpInside)
        
        cancelButton.setTitleColor(.black,
                                   for: .normal)
        
        cancelButton.layer.cornerRadius = 23
        cancelButton.clipsToBounds = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.reloadAllComponents()
    }
    
    func initViewFrame() {
        contentView.mas_makeConstraints { make in
            make?.left.equalTo()(16)
            make?.right.bottom().equalTo()(-16)
            make?.height.equalTo()(354)
        }
        
        effectView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
        
        backgroundImageView.mas_makeConstraints { make in
            make?.top.left().equalTo()(0)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.left.top().equalTo()(24)
        }
        
        pickerView.mas_makeConstraints { make in
            make?.top.equalTo()(60)
            make?.left.equalTo()(20)
            make?.right.equalTo()(-20)
            make?.bottom.equalTo()(-93)
        }
        
        submitButton.mas_makeConstraints { make in
            make?.bottom.equalTo()(-30)
            make?.right.equalTo()(-12)
            make?.height.equalTo()(46)
            make?.width.equalTo()(190)
        }
        
        cancelButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(submitButton)
            make?.right.equalTo()(submitButton.mas_left)?.offset()(-15)
            make?.height.equalTo()(46)
            make?.width.equalTo()(110)
        }
    }
    
    func updateViewProperties() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        contentView.backgroundColor = .white
        
        backgroundImageView.image = UIImage(named: "fcr_alert_bg")
        
        titleLabel.textColor = .black
        titleLabel.text = "fcr_create_select_start_time".localized()
        
        submitButton.setTitle("fcr_alert_sure".localized(),
                              for: .normal)
        
        submitButton.backgroundColor = UIColor(hex: 0x357BF6)
        
        cancelButton.setTitle("fcr_alert_cancel".localized(),
                              for: .normal)
        
        cancelButton.backgroundColor = UIColor(hex: 0xF8F8F8)
    }
}

private extension FcrAppUICreateRoomTimePickerController {
    func initDate() -> Date {
        var date = Date()
        
        if let multip = minuteIsMultipleOfFive(minute: date.minute) {
            if multip == 60 {
                date.hour += 1
                date.minute = 0
            } else {
                date.minute = multip
            }
        }
        
        return date
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
            print(">>>>>>>>>> minuteIsMultipleOfFive minute: \(minute)")
            print(">>>>>>>>>> minuteIsMultipleOfFive multip: \(multip)")
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
    
    func printDebug(_ text: String) {
        print(">>>>>>>>>> \(text)")
    }
}

// MARK: - Actions
private extension FcrAppUICreateRoomTimePickerController {
    @objc func onClickCancel(_ sender: UIButton) {
        dismiss(animated: true)
        complete = nil
    }
    
    @objc func onClickSubmmit(_ sender: UIButton) {
//        var date = days[pickerView.selectedRow(inComponent: kComponentDay)]
//        date.hour = hours[pickerView.selectedRow(inComponent: kComponentHour)]
//        date.minute = minutes[pickerView.selectedRow(inComponent: kComponentMinute)]
//
//        guard date > Date() else {
//            showToast("fcr_create_tips_starttime".localized(),
//                      type: .warning)
//            return
//        }
//
//        complete?(date)
//
//        dismiss(animated: true)
//
//        complete = nil
    }
}

// MARK: - UIPickerView Call Back
extension FcrAppUICreateRoomTimePickerController: UIPickerViewDelegate,
                                         UIPickerViewDataSource {
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
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        let type = FcrAppUIDateType.create(with: component)
        
        let date = getDateFromPicker()
        
        guard valid(date: date) else {
            return
        }
        
        
        let last = selectedDate
        printDebug("last: \(last.desc())")
        selectedDate = date
        
        updateDataSource(date: date)
        
//
        switch type {
        case .day:
            pickerView.reloadComponent(FcrAppUIDateType.hour.component())
            pickerView.reloadComponent(FcrAppUIDateType.minute.component())
            
            
            DispatchQueue.main.async {
                self.selectPickerRow(type: .hour,
                                     value: last.hour)
                
                self.selectPickerRow(type: .minute,
                                     value: last.minute)
            }
        case .hour:
            pickerView.reloadComponent(FcrAppUIDateType.minute.component())
            
            DispatchQueue.main.async {
                self.selectPickerRow(type: .minute,
                                     value: last.minute)
            }
        default:
            break
        }
        
//        checkout(date: date)
        
//        switch type {
//        case .day:
//            handleDay(date: date)
//        case .hour:
//           handleHour(date: date)
//        default:
//            break
//        }
        
        print(">>>>>>>>>>>>>>> >>>>>>>>>>>>>>>")
    }
    
    func valid(date: Date) -> Bool {
        let current = initDate()
        
        if date > current {
            return true
        } else {
            resetDataSource(date: current)
            pickerView.reloadAllComponents()
            
            pickerScroll(to: 0,
                         type: .hour)
            
            pickerScroll(to: 0,
                         type: .minute)
            
            printDebug("invalid")
            selectedDate = current
            return false
        }
    }
    
    func updateDataSource(date: Date) {
        if date.isInToday {
            let current = initDate()
            
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
            if let select = hours.firstIndex(where: {$0 == value}) {
                print(">>>>>>>>>> hours firstIndex: \(select), \(value)")
                
                pickerView.selectRow(select,
                                     inComponent: FcrAppUIDateType.hour.component(),
                                     animated: false)
            }
        case .minute:
            if let select = minutes.firstIndex(where: {$0 == value}) {
                print(">>>>>>>>>> minutes firstIndex: \(select), \(value)")
                
                pickerView.selectRow(select,
                                     inComponent: FcrAppUIDateType.minute.component(),
                                     animated: false)
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
    
            
    
    
//    func handleDay(date: Date) {
//        let last = selectedDate
//
////        guard last.isInToday != date.isInToday else {
////            return
////        }
//
//        guard !reset(date: date) else {
//            return
//        }
//
//
//
//        if date.isInToday {
//            let current = initDate()
//            hours = createHourList(date: current)
//
//            print(">>>>>>>>>> handleDay isInToday")
//        } else {
//            hours = createHourList(date: date)
//        }
//
//        print(">>>>>>>>>> handleDay")
//
//        minutes = createMinuteList(date: date)
//
//        pickerView.reloadComponent(FcrAppUIDateType.hour.component())
//        pickerView.reloadComponent(FcrAppUIDateType.minute.component())
//
//        if let select = hours.firstIndex(where: {$0 == last.hour}) {
//            print(">>>>>>>>>> hours firstIndex: \(select), \(last.hour)")
//
//            pickerView.selectRow(select,
//                                 inComponent: FcrAppUIDateType.hour.component(),
//                                 animated: false)
//        }
//
//        if let select = minutes.firstIndex(where: {$0 == last.minute}) {
//            print(">>>>>>>>>> minutes firstIndex: \(select), \(last.minute)")
//
//            pickerView.selectRow(select,
//                                 inComponent: FcrAppUIDateType.minute.component(),
//                                 animated: false)
//        }
//
//        selectedDate = date
//    }
//
//    func handleHour(date: Date) {
//        let last = selectedDate
//
////        guard last.isInCurrent(.hour) != date.isInCurrent(.hour) else {
////            return
////        }
//
//        guard !reset(date: date) else {
//            return
//        }
//
//        minutes = createMinuteList(date: date)
//
//        pickerView.reloadComponent(<#T##component: Int##Int#>)
//
//        pickerView.reloadComponent(FcrAppUIDateType.minute.component())
//
//        if let select = minutes.firstIndex(where: {$0 == last.minute}) {
//            pickerView.selectRow(select,
//                                 inComponent: FcrAppUIDateType.minute.component(),
//                                 animated: false)
//        }
//
//        selectedDate = date
//    }
//
//    func reset(date: Date) -> Bool {
//        let current = initDate()
//
//        guard date < current else {
//            return false
//        }
//
//        print(">>>>>>>>>> reset")
//
//        updateDataSource(date: current)
//
//        selectedDate = current
//
//        pickerView.reloadAllComponents()
//
//        DispatchQueue.main.async {
//            pickerView.selectRow(0, inComponent: FcrAppUIDateType.hour.component(), animated: false)
//            pickerView.selectRow(0, inComponent: FcrAppUIDateType.minute.component(), animated: false)
//        }
//
//
//
//        return true
//    }
}

fileprivate extension Date {
    func desc() -> String {
        return "\(day), \(hour), \(minute)"
    }
}
