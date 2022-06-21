//
//  AddIncoiceFormRouter.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

struct AddIncoiceFormRouter: AddIncoiceFormRouterProtocol {
    
    func route(to destination: AddIncoiceFormDestination) {
        switch destination {
            case .navigateBack: break
            case .cancel: break
        }
    }
}
