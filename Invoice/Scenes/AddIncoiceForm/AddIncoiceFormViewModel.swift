//
//  AddIncoiceFormViewModel.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Foundation
import Combine

class AddIncoiceFormViewModel: AddIncoiceFormViewModelInputs, AddIncoiceFormViewModelOutputs {
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: AddIncoiceFormViewModelProtocol
    
    @Published private(set) var title: String?
    
    let navigateToDestination = PassthroughSubject< AddIncoiceFormDestination, Never>()
    //MARK: -
    
    //MARK: AddIncoiceFormViewModelProtocol
    
    let viewDidLoad = PassthroughSubject<(), Never>()
    
    let viewDidAppear = PassthroughSubject<(), Never>()
    
    let tapNavigateBack = PassthroughSubject<(), Never>()

    let tapCancel = PassthroughSubject<(), Never>()

    //MARK: -
    private let router: AddIncoiceFormRouter

    init(router: AddIncoiceFormRouter, invoice: InvoiceRecord? = nil) {
        self.router = router
        
        outputs.navigateToDestination
            .sink(receiveValue: router.route(to:))
            .store(in: &cancellables)

        title = "AddIncoiceForm"
        
        tapNavigateBack.map({ _ -> AddIncoiceFormDestination in .navigateBack })
            .merge(with: tapCancel.map({ _ -> AddIncoiceFormDestination in .cancel }))
            .subscribe(navigateToDestination)
            .store(in: &cancellables)
    }
}

extension AddIncoiceFormViewModel {
    
}

extension AddIncoiceFormViewModel: AddIncoiceFormViewModelProtocol {
    
    var inputs: AddIncoiceFormViewModelInputs { self }
    var outputs: AddIncoiceFormViewModelOutputs { self }
}
