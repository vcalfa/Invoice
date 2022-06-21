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
        switch destination {
        case .addingInvoice:
            navigateAddInvoice()
        case .detailInvoice(uuid: let uuid):
            showDetailInvoice(uuid)
        }
    }
    
    func navigateAddInvoice() {
        let pickerController = CameraViewController(configurator: CameraConfigurator())
        viewController?.present(pickerController, animated: true)
    }
    
    func showDetailInvoice(_ id: UUID) {
        print("navigateDetailInvoice ID: \(id)")
    }
}
