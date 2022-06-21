//___FILEHEADER___

import Foundation

struct ___VARIABLE_productName:identifier___Configurator: ConfiguratorProtocol {
    typealias Controller = ___VARIABLE_productName:identifier___ViewController
    
    func configure(controller: Controller) -> Controller.ViewModelType {
        return ___VARIABLE_productName:identifier___ViewModel(router: ___VARIABLE_productName:identifier___Router())
    }
}