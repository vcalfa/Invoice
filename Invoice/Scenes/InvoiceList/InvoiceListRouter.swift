//
//  InvoiceListRouter.swift
//  Invoice
//
//  Created by Vladimir Calfa on 20/06/2022.
//

import Foundation
import UIKit

struct InvoiceListRouter: InvoiceListRouterProtocol {
    private weak var viewController: UIViewController?

    init(_ viewController: UIViewController?) {
        self.viewController = viewController
    }

    func route(to destination: InvoiceListDestination) {
        dump(destination, name: "InvoiceListRouter")
        switch destination {
        case .addingInvoice:
            navigateAddInvoice()
        case let .detailInvoice(uuid: uuid):
            showDetailInvoice(uuid)
        }
    }

    func navigateAddInvoice() {
        let pickerController = CameraViewController(configurator: CameraConfigurator())
        viewController?.present(pickerController, animated: true)
    }

    func showDetailInvoice(_ id: UUID) {
        let configurator = AddInvoiceFormConfigurator(invoiceId: id)
        let addInvoiceForm = AddInvoiceFormViewController(configurator: configurator)
        let navigationController = UINavigationController(rootViewController: addInvoiceForm)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
