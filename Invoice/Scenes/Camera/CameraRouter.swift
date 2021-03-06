//
//  CameraRouter.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import UIKit

struct CameraRouter: CameraRouterProtocol {
    private weak var viewController: UIViewController?

    init(_ viewController: UIViewController?) {
        self.viewController = viewController
    }

    func route(to destination: CameraDestination) {
        switch destination {
        case .cancel:
            viewController?.dismiss(animated: true, completion: nil)
        case let .finishAction(invoice: invoice):
            let configurator = AddInvoiceFormConfigurator(invoice: invoice)
            let addInvoiceForm = AddInvoiceFormViewController(configurator: configurator)
            let navigationController = UINavigationController(rootViewController: addInvoiceForm)
            viewController?.dismiss(animated: true, completion: nil)
            viewController?.presentingViewController?.present(navigationController,
                                                              animated: true,
                                                              completion: nil)
        }
    }
}
