//
//  InvoiceListStateRestorationProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 04/07/2022.
//

import Foundation
import UIKit

protocol InvoiceListStateRestorationProtocol {
    func restore(_ userActivity: NSUserActivity?) -> Bool
}

struct InvoiceListStateRestoration: InvoiceListStateRestorationProtocol {
    private weak var viewController: UIViewController?

    init(_ viewController: UIViewController?) {
        self.viewController = viewController
    }

    func restore(_ userActivity: NSUserActivity?) -> Bool {
        dump(userActivity, name: "Restore with userActvityObject")

        switch userActivity?.registredActivityType {
        case InfoPlist.ActivityType.takePhoto?:
            let invoiceItem = InvoiceItem(userActivity: userActivity)
            navigateAddInvoice(invoiceItem)
            return true
        case InfoPlist.ActivityType.editInvoice?:
            guard let invoiceItem = InvoiceItem(userActivity: userActivity) else {
                return false
            }
            showDetailInvoice(invoiceItem)
        default:
            return false
        }

        return false
    }

    func navigateAddInvoice(_ invoice: InvoiceItem?) {
        let pickerController = CameraViewController(configurator: CameraConfigurator(invoice: invoice))
        viewController?.present(pickerController, animated: true)
    }

    func showDetailInvoice(_ invoice: InvoiceItem?) {
        let configurator = AddIncoiceFormConfigurator(invoice: invoice)
        let addInvoiceForm = AddIncoiceFormViewController.instance(configurator: configurator)
        let navigationController = UINavigationController(rootViewController: addInvoiceForm)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
