//
//  Configurator.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import UIKit

protocol ConfigurableViewControllerProtocol: AnyObject {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }
}

extension ConfigurableViewControllerProtocol where Self: UIViewController {
    init<T: ConfiguratorProtocol>(configurator: T) where Self == T.Controller {
        self.init()
        viewModel = configurator.configure(controller: self)
    }
    
    init<T: ConfiguratorProtocol>(nibName: String? = String(describing: Self.self),
                                              bundle: Bundle?,
                                              configurator: T) where Self == T.Controller {
        self.init(nibName: nibName, bundle: bundle)
        viewModel = configurator.configure(controller: self)
    }
}

protocol ConfiguratorProtocol {
    associatedtype Controller: ConfigurableViewControllerProtocol

    func configure(controller: Controller) -> Controller.ViewModelType
}
