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
}

protocol ConfiguratorProtocol {
    associatedtype Controller: ConfigurableViewControllerProtocol

    func configure(controller: Controller) -> Controller.ViewModelType
}

extension ConfigurableViewControllerProtocol where Self: UIViewController {
    func configure<T: ConfiguratorProtocol>(configurator: T) where Self == T.Controller {
        viewModel = configurator.configure(controller: self)
    }
}

protocol Instantiable: AnyObject {
    static func instance<T: ConfiguratorProtocol>(configurator: T) -> Self where Self == T.Controller
}

extension Instantiable where Self: UIViewController {
    static func instance<T: ConfiguratorProtocol>(configurator: T) -> Self where Self == T.Controller {
        let controller = Self(nibName: String(describing: Self.self), bundle: nil)
        controller.configure(configurator: configurator)
        return controller
    }
}
