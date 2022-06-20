//
//  Configurator.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

//import Foundation
//import UIKit
//
//extension UIViewController: ConfigurableViewControllerProtocol {
//    convenience init<T: ConfiguratorProtocol>(configurator: T) where Self.ParamsType == T.Controller.ParamsType  {
//        self.init()
//        self.params = configurator.configure(controller: self)
//    }
//}
//
//protocol ConfiguratorProtocol {
//    
//    associatedtype Controller: ConfigurableViewControllerProtocol
//    
//    func configure(controller: Controller) -> Controller.ParamsType
//}
//
//
//protocol ConfigurableViewControllerProtocol: AnyObject {
//    associatedtype ParamsType
//    
//    var params: ParamsType! { get set }
//}
//
//extension ConfigurableViewControllerProtocol where Self: UIViewController {
//    func configure<T: ConfiguratorProtocol>(configurator: T) where Self == T.Controller {
//        self.params = configurator.configure(controller: self)
//    }
//}
//
//
//protocol Instantiable: AnyObject {
//    
//    static func instance<T: ConfiguratorProtocol>(configurator: T) -> Self where Self == T.Controller
//}
//
//extension Instantiable where Self: UIViewController {
//    
//    static func instance<T: ConfiguratorProtocol>(configurator: T) -> Self where Self == T.Controller {
//        let contr: Self = Self(nibName: nil, bundle: nil)
//        contr.configure(configurator: configurator)
//        return contr
//    }
//}
