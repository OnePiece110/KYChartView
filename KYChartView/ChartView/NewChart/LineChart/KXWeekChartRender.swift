//
//  KXWeekChartRender.swift
//  KYChartView
//
//  Created by mac on 2023/10/26.
//

import UIKit

class KXWeekChartRender<Input: KYChartQuote>: KYChartRenderProtcol {
    
    private var labels = [Int: UILabel]()
    
    func setup(in view: KYChartRenderView<Input>) {
        
    }
    
    func render(in view: KYChartRenderView<Input>, context: KYChartContext<Input>) {
        let contextRect = CGRect(x: context.contentRect.minX, y: context.contentRect.minY, width: view.frame.width, height: context.contentRect.height)
        let weekDates = Date().weekDates
        let width = contextRect.width / CGFloat(weekDates.count)
        for (index, date) in weekDates.enumerated() {
            let point = CGPoint(x: context.layout.quoteMidX(at: index), y: context.yOffset(for: view.data[index].value))
            let label = getLabel(in: view, with: index, context: context)
            label.center = CGPoint(x: point.x, y: contextRect.height / 2)
            label.text = "\(date.dayOfTheWeek)"
            if index == context.selectedIndex {
                label.backgroundColor = UIColor.black
                label.textColor = .white
            } else {
                label.backgroundColor = .clear
                label.textColor = .black
            }
        }
    }
    
    func getLabel(in view: KYChartRenderView<Input>, with index: Int, context: KYChartContext<Input>) -> UILabel {
        if let label = labels[index] {
            return label
        } else {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .center
            label.frame = CGRect(origin: .zero, size: CGSize(width: 24, height: context.contentRect.height))
            view.addSubview(label)
            labels[index] = label
            return label
        }
    }
    
    func tearDown(in view: KYChartRenderView<Input>) {
        for (_, value) in labels {
            value.removeFromSuperview()
        }
    }
    
}

extension Date {
    func isSameDay(other: Date) -> Bool {
        let calendar = Calendar.current
        
        let dateComponents1 = calendar.dateComponents([.year, .month, .day], from: other)
        let dateComponents2 = calendar.dateComponents([.year, .month, .day], from: self)
        
        return dateComponents1.year == dateComponents2.year &&
               dateComponents1.month == dateComponents2.month &&
               dateComponents1.day == dateComponents2.day
    }
    
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return sunday!
    }
    
    var weekDates: [Date] {
        var dates: [Date] = []
        for i in 0..<7 {
            dates.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        return dates
    }
    
    var dayOfTheWeek: Int {
        let dayNumber = Calendar.current.component(.weekday, from: self)
        return dayNumber - 1
    }
    
    var day: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 1
    }
    
    var startOfNextWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .weekOfMonth, value: 1, to: sunday!)!
    }
    
    var startOfPreviousWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .weekOfMonth, value: -1, to: sunday!)!
    }
}
