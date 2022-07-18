//
//  AddIncoiceFormViewModel+UserActivity.swift
//  Invoice
//
//  Created by Vladimir Calfa on 04/07/2022.
//

import Foundation

extension AddInvoiceFormViewModel: NSUserActivityDelegate {
    func userActivityWillSave(_ userActivity: NSUserActivity) {
        updatedValue?.addEntries(into: userActivity)
    }
}
