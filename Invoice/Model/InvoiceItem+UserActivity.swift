//
//  InvoiceItem+UserActivity.swift
//  Invoice
//
//  Created by Vladimir Calfa on 04/07/2022.
//

import Foundation

extension InvoiceItem {
    func addEntries(into userActivity: NSUserActivity) {
        let data = try? JSONEncoder().encode(self)
        let invoiceItemData = [UserActivityKey.invoiceItemKey: data]
        userActivity.addUserInfoEntries(from: invoiceItemData as [AnyHashable: Any])
    }
    
    init?(userActivity: NSUserActivity?) {
        
        guard let data = userActivity?.userInfo?[UserActivityKey.invoiceItemKey] as? Data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            self = try decoder.decode(InvoiceItem.self, from: data)
        } catch {
            return nil
        }
    }
}
