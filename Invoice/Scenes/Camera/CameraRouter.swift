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
        case .finishAction(invoice: let invoice):
            let configurator = AddIncoiceFormConfigurator(invoice: invoice)
            let addInvoiceForm = AddIncoiceFormViewController.instance(configurator: configurator)
            let navigationController = UINavigationController(rootViewController: addInvoiceForm)
            viewController?.dismiss(animated: true, completion: nil)
            viewController?.presentingViewController?.present(navigationController,
                                                              animated: true,
                                                              completion: nil)
        }
    }
}
