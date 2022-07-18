//
//  StateRestoration.swift
//  Invoice
//
//  Created by Vladimir Calfa on 03/07/2022.
//

import Foundation
import UIKit

enum UserActivityKey {
    static let invoiceItemKey = "invoiceKey"
}

protocol StateRestorable {
    var defaultUserActivity: NSUserActivity? { get }

    func updateUserActivity(_ userActivity: NSUserActivity?) -> NSUserActivity?

    func configureUserActivity()
    
    func clearRestoreState()

    @discardableResult func restore(with userActivity: NSUserActivity?) -> Bool
}

extension StateRestorable where Self: UIViewController {
    func updateUserActivity(_ userActivity: NSUserActivity?) -> NSUserActivity? {
        return userActivity
    }

    func clearRestoreState() {
        view.window?.windowScene?.userActivity = nil
    }
    
    func configureUserActivity() {
        let currentUserActivity = defaultUserActivity
        view.window?.windowScene?.userActivity = updateUserActivity(currentUserActivity)
    }

    @discardableResult func restore(with _: NSUserActivity?) -> Bool { return true }
}
