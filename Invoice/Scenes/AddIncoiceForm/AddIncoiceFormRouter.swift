//
//  AddIncoiceFormRouter.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import UIKit

struct AddIncoiceFormRouter: AddIncoiceFormRouterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(_ viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func route(to destination: AddIncoiceFormDestination) {
        switch destination {
            case .navigateBack:
                print("AddIncoiceFormRouter.navigateBack")
                viewController?.dismiss(animated: true)
            case .cancel:
                print("AddIncoiceFormRouter.cancel")
                viewController?.dismiss(animated: true)
            case .editPhoto(invoice: let invoice):
                print("AddIncoiceFormRouter.editPhoto")
                let cameraController = CameraViewController(configurator: CameraConfigurator(invoice: invoice))
                viewController?.dismiss(animated: true, completion: nil)
                viewController?.presentingViewController?.present(cameraController,
                                                                  animated: true,
                                                                  completion: nil)
        }
    }
}
