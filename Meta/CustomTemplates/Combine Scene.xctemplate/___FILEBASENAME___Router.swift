// ___FILEHEADER___

import UIKit

struct ___VARIABLE_productName:identifier___Router: ___VARIABLE_productName: identifier___RouterProtocol {
    private weak var viewController: UIViewController?

    init(_ viewController: UIViewController?) {
        self.viewController = viewController
    }

    func route(to destination: ___VARIABLE_productName: identifier___Destination) {
        switch destination {
        case .navigateBack:
            break
        case .cancel:
            viewController?.dismiss(animated: true, completion: nil)
        }
    }
}
