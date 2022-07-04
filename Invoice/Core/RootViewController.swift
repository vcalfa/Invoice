//
//  RootViewController.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import UIKit

final class RootViewController {
    private init() {}

    static func viewController() -> UIViewController {
        let invoiceList = InvoiceListViewController(configurator: InvoiceListConfigurator())
        return UINavigationController(rootViewController: invoiceList)
    }
}
