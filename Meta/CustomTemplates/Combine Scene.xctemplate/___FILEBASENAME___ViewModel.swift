//___FILEHEADER___

import Foundation
import Combine

class ___VARIABLE_productName:identifier___ViewModel: ___VARIABLE_productName:identifier___ViewModelInputs, ___VARIABLE_productName:identifier___ViewModelOutputs {
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: ___VARIABLE_productName:identifier___ViewModelProtocol
    
    @Published private(set) var title: String?
    
    let navigateToDestination = PassthroughSubject< ___VARIABLE_productName:identifier___Destination, Never>()
    //MARK: -
    
    //MARK: ___VARIABLE_productName:identifier___ViewModelProtocol
    
    let viewDidLoad = PassthroughSubject<(), Never>()
    
    let viewDidAppear = PassthroughSubject<(), Never>()
    
    let tapNavigateBack = PassthroughSubject<(), Never>()

    let tapCancel = PassthroughSubject<(), Never>()

    //MARK: -
    private let router: ___VARIABLE_productName:identifier___Router

    init(router: ___VARIABLE_productName:identifier___Router) {
        self.router = router
        
        outputs.navigateToDestination
            .sink(receiveValue: router.route(to:))
            .store(in: &cancellables)

        title = "___VARIABLE_productName:identifier___"
        
        tapNavigateBack.map({ _ -> ___VARIABLE_productName:identifier___Destination in .navigateBack })
            .merge(with: tapCancel.map({ _ -> ___VARIABLE_productName:identifier___Destination in .cancel }))
            .subscribe(navigateToDestination)
            .store(in: &cancellables)
    }
}

extension ___VARIABLE_productName:identifier___ViewModel {
    
}

extension ___VARIABLE_productName:identifier___ViewModel: ___VARIABLE_productName:identifier___ViewModelProtocol {
    
    var inputs: ___VARIABLE_productName:identifier___ViewModelInputs { self }
    var outputs: ___VARIABLE_productName:identifier___ViewModelOutputs { self }
}
