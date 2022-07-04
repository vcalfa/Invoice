//
//  CameraViewModel+UserActivity.swift
//  Invoice
//
//  Created by Vladimir Calfa on 04/07/2022.
//

import Foundation

extension CameraViewModel: NSUserActivityDelegate {
    func userActivityWillSave(_ userActivity: NSUserActivity) {
        invoice?.addEntries(into: userActivity)
    }
}
