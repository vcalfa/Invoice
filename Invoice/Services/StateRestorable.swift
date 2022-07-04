//
//  StateRestoration.swift
//  Invoice
//
//  Created by Vladimir Calfa on 03/07/2022.
//

import Foundation
import UIKit

// NOTE: consider to use SwiftGen to generate this enum from Info.plist file
enum ActivityType {
    static let editInvoice = "sk.calfavladimir.visma.Invoice.activity.editInvoice"
    static let takePhoto = "sk.calfavladimir.visma.Invoice.activity.takePhoto"
}

enum UserActivityKey {
    static let invoiceItemKey = "invoiceKey"
}

protocol StateRestorable {
    var defaulUserActivity: NSUserActivity? { get }

    func updateUserActivity(_ userActivity: NSUserActivity?) -> NSUserActivity?

    func configureUserActivity()

    @discardableResult func restore(with userActivity: NSUserActivity?) -> Bool
}

extension StateRestorable where Self: UIViewController {
    func updateUserActivity(_ userActivity: NSUserActivity?) -> NSUserActivity? {
        return userActivity
    }

    func configureUserActivity() {
        let currentUserActivity = defaulUserActivity
        view.window?.windowScene?.userActivity = updateUserActivity(currentUserActivity)
    }

    @discardableResult func restore(with _: NSUserActivity?) -> Bool { return true }
}
