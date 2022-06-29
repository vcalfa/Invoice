//
//  Invoice+CoreDataClass.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//
//

import Foundation
import CoreData

@objc(Invoice)
public class Invoice: NSManagedObject {

    func update(with item: InvoiceItem) {
        note = item.note
        date = item.date
        total = item.total.map{ NSNumber(value: $0) }
        imageId = item.imageId
        currencyCode = item.currencyCode
    }
    
    @objc
    var relativeDay: String {
        
        guard let date = self.date else {
            return "Unknown"
        }
        
        if Calendar.current.isDateInToday(date) {
            return "Today"
        }
        else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        else if Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 8 <= 7 {
            return "Resent 7 days"
        }
        else if Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 31 <= 30 {
            return "Resent 30 days"
        }
        else if Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? -1 >= 0 {
            return "In future"
        }
        
        return date.dateString("YYYY MMMM")
    }
}
