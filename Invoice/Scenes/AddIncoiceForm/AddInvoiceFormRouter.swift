//
//  AddInvoiceFormRouter.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import UIKit

struct AddInvoiceFormRouter: AddInvoiceFormRouterProtocol {
    private weak var viewController: UIViewController?

    init(_ viewController: UIViewController?) {
        self.viewController = viewController
    }

    func route(to destination: AddInvoiceFormDestination) {
        dump(destination, name: "AddInvoiceFormRouter")
        switch destination {
        case .navigateBack:
            viewController?.dismiss(animated: true)
        case .cancel:
            viewController?.dismiss(animated: true)
        case let .editPhoto(invoice: invoice):
            let cameraController = CameraViewController(configurator: CameraConfigurator(invoice: invoice))
            viewController?.dismiss(animated: true, completion: nil)
            viewController?.presentingViewController?.present(cameraController,
                                                              animated: true,
                                                              completion: nil)
        }
    }
}
